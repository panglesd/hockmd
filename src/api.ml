open Lwt
open Cohttp
open Cohttp_lwt_unix
open Utils

module V1 = struct
  open Types_and_parser.V1
  open Combined_syntax

  type token = string
  type error = [ `Msg of string ]

  let error_of_request _resp _code body =
    ignore (Cohttp_lwt.Body.to_string body >|= fun s -> failwith s);
    `Msg "fucked!: "

  let token_of_string = Fun.id
  let default_api_url = "https://api.hackmd.io/v1/"

  let get ?(api_url = default_api_url) url token =
    let headers =
      Header.init () |> fun header ->
      Header.add header "Authorization" @@ "Bearer " ^ token
    in
    let uri = Uri.of_string (api_url ^ url) in
    Client.get ~headers uri >>= fun (resp, body) ->
    let code = resp |> Response.status |> Code.code_of_status in
    if code != 200 then Lwt.return @@ Error (error_of_request resp code body)
    else
      body |> Cohttp_lwt.Body.to_string >|= Yojson.Safe.from_string
      >|= Result.ok

  let update
      (f :
        ?ctx:Net.ctx ->
        ?body:Cohttp_lwt.Body.t ->
        ?chunked:bool ->
        ?headers:Header.t ->
        'a ->
        'b) g expected_code ?(api_url = default_api_url) url body token =
    let headers =
      let add a b h = Header.add h a b in
      Header.init ()
      |> add "Authorization" @@ "Bearer " ^ token
      |> add "Content-Type" "application/json"
      |> add "Accept" "application/json, text/plain, */*"
      |> add "Connection" "closed"
    in
    let uri = Uri.of_string (api_url ^ url) in
    let body =
      let ( >>| ) a b = Option.map b a in
      body >>| Yojson.Safe.to_string
      >>| (fun x -> x ^ "\n")
      >>| Cohttp_lwt.Body.of_string
    in
    f ?body ~chunked:false ~headers uri >>= fun (resp, body) ->
    let code = resp |> Response.status |> Code.code_of_status in
    if code != expected_code then
      Lwt.return @@ Error (error_of_request resp code body)
    else body |> Cohttp_lwt.Body.to_string >|= g >|= Result.ok

  let post = update Client.post Yojson.Safe.from_string 201
  let patch = update Client.patch Fun.id 202
  let delete = update Client.delete Fun.id 204

  let user ?api_url token =
    let++ body = get ?api_url "me" token in
    user_of_yojson body

  let notes ?api_url token =
    let++ body = get ?api_url "notes" token in
    body |> Yojson.Safe.Util.to_list |> List.map note_summary_of_yojson

  let note ?api_url token note_id =
    let url = Format.sprintf "notes/%s" (string_of_note_id note_id) in
    let++ body = get ?api_url url token in
    try note_of_yojson body
    with Ppx_yojson_conv_lib__Yojson_conv.Of_yojson_error (exn, _) ->
      raise exn

  let teams ?api_url token =
    let++ body = get ?api_url "teams" token in
    body |> Yojson.Safe.Util.to_list |> List.map team_of_yojson

  let team_notes ?api_url token team_path =
    let url = Format.sprintf "teams/%s/notes" (string_of_team_path team_path) in
    let++ body = get ?api_url url token in
    body |> Yojson.Safe.Util.to_list |> List.map note_of_yojson

  let create_note ?api_url token new_note =
    let body = Option.map yojson_of_new_note new_note in
    let++ answer = post ?api_url "notes" body token in
    note_of_yojson answer

  let update_note ?api_url token note_id update_note =
    let url = Format.sprintf "notes/%s" (string_of_note_id note_id) in
    let body = Option.map yojson_of_update_note update_note in
    let rec doit () =
      let** answer = patch ?api_url url body token in
      match update_note with
      | None -> Lwt.return_ok answer
      | Some { content; _ } ->
          let** note = note ?api_url token note_id in
          if note.content = content then Lwt.return_ok answer else doit ()
    in
    doit ()

  let delete_note ?api_url token note_id =
    let url = Format.sprintf "notes/%s" (string_of_note_id note_id) in
    let++ answer = delete ?api_url url None token in
    answer

  let history ?api_url token =
    let++ body = get ?api_url "history" token in
    body |> Yojson.Safe.Util.to_list |> List.map note_summary_of_yojson

  let create_note_in_team ?api_url token team_path new_note =
    let url = Format.sprintf "teams/%s/notes" (string_of_team_path team_path) in
    let body = Option.map yojson_of_new_note new_note in
    let++ answer = post ?api_url url body token in
    note_of_yojson answer

  let update_note_in_team ?api_url token team_path note_id update_note =
    let url =
      Format.sprintf "teams/%s/notes/%s"
        (string_of_team_path team_path)
        (string_of_note_id note_id)
    in
    let body = Option.map yojson_of_update_note update_note in
    let++ answer = patch ?api_url url body token in
    answer

  let delete_note_in_team ?api_url token team_path note_id =
    let url =
      Format.sprintf "teams/%s/notes/%s"
        (string_of_team_path team_path)
        (string_of_note_id note_id)
    in
    let++ answer = delete ?api_url url None token in
    answer
end
