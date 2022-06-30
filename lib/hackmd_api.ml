let greet name = "Hello " ^ name ^ "!"

module Result_syntax = struct
  let ( let* ) = Result.bind
  let ( let+ ) a b = Result.map b a
end

module Combined_syntax = struct
  let ( let++ ) a b =
    let open Lwt.Syntax in
    let+ x = a in
    let open Result_syntax in
    let+ x = x in
    b x

  let ( let** ) a b =
    let open Lwt.Syntax in
    let* x = a in
    match x with Error e -> Lwt.return (Error e) | Ok o -> b o

  let ( let*+ ) a b =
    let open Lwt.Syntax in
    let* x = a in
    match x with
    | Error e -> Lwt.return (Error e)
    | Ok o ->
        let+ r = b o in
        Ok r

  let ( let+* ) a b =
    let open Lwt.Syntax in
    let+ x = a in
    let open Result_syntax in
    let* x = x in
    b x
end

open Lwt
open Cohttp
open Cohttp_lwt_unix

type user_id = string [@@deriving show]
type team_id = string [@@deriving show]
type user_path = string [@@deriving show]
type team_path = string [@@deriving show]
type error = Cohttp_lwt_unix.Response.t * Cohttp_lwt.Body.t

type team = {
  id : team_id;
  ownerId : user_id;
  path : string;
  name : string;
  logo : string;
  description : string;
  visibility : string;
  createdAt : int;
}
[@@deriving show]

let team_of_json team_j =
  let open Yojson.Safe.Util in
  let get_member_s field = to_string @@ member field team_j
  and get_member_i field = to_int @@ member field team_j in
  {
    id = get_member_s "id";
    ownerId = get_member_s "ownerId";
    path = get_member_s "path";
    name = get_member_s "name";
    logo = get_member_s "logo";
    description = get_member_s "description";
    visibility = get_member_s "visibility";
    createdAt = get_member_i "createdAt";
  }

type user = {
  id : user_id;
  name : string;
  email : string option;
  userPath : string;
  photo : string;
  teams : team list;
}
[@@deriving show]

let user_of_yojson user_j =
  let open Yojson.Safe.Util in
  let get_member_s field = to_string @@ member field user_j
  and get_member_so field = to_string_option @@ member field user_j in
  {
    id = get_member_s "id";
    name = get_member_s "name";
    email = get_member_so "email";
    userPath = get_member_s "userPath";
    photo = get_member_s "photo";
    teams = List.map team_of_json @@ to_list @@ member "teams" user_j;
  }

let get url token =
  let headers =
    Header.init () |> fun header ->
    Header.add header "Authorization" @@ "Bearer " ^ token
  in
  let uri = Uri.of_string ("https://api.hackmd.io/v1/" ^ url) in
  Client.get ~headers uri >>= fun (resp, body) ->
  let code = resp |> Response.status |> Code.code_of_status in
  if code != 200 then Lwt.return @@ Error (resp, body)
  else
    body |> Cohttp_lwt.Body.to_string >|= Yojson.Safe.from_string
    >|= fun yojson ->
    Format.printf "yojson is: %a\n" Yojson.Safe.pp yojson;
    Result.ok yojson

let user token =
  let open Combined_syntax in
  let++ body = get "me" token in
  user_of_yojson body

let f () =
  let open Combined_syntax in
  let++ user = user "5OK9TFX0HAD1SDXDIZG0P1CCZZ6G2SEOCTXFRHHZBYD3K9B75J" in
  Format.printf "%a" pp_user user

type note_id = string [@@deriving show]
type publish_type = string (* View, ... *) [@@deriving show]
type rw_permission = Owner | Signed_in | Guest [@@deriving show]

let rw_permission_of_yojson yojson =
  match Yojson.Safe.Util.to_string yojson with
  | "owner" -> Owner
  | "signed_in" -> Signed_in
  | "guest" -> Guest
  | _ -> failwith "TODO"

type comment_permission =
  | Disabled
  | Forbidden
  | Owners
  | Signed_in_users
  | Everyone
[@@deriving show]

let comment_permission_of_yojson yojson =
  match Yojson.Safe.Util.to_string yojson with
  | "disabled" -> Disabled
  | "forbidden" -> Forbidden
  | "owners" -> Owners
  | "signed_in_users" -> Signed_in_users
  | "everyone" -> Everyone
  | _ -> failwith "TODO"

type change_user = {
  name : string;
  photo : string;
  biography : string option;
  userPath : user_path;
}
[@@deriving show]

let change_user_of_yojson yojson =
  match yojson with
  | `Null -> None
  | _ ->
      let open Yojson.Safe.Util in
      let get_member_s field = to_string @@ member field yojson
      and get_member_so field = to_string_option @@ member field yojson in
      Some
        {
          name = get_member_s "name";
          photo = get_member_s "photo";
          biography = get_member_so "biography";
          userPath = get_member_s "userPath";
        }

type note = {
  id : note_id;
  title : string;
  tags : string list;
  createdAt : int;
  publishType : publish_type;
  publishedAt : int option;
  permalink : string option;
  shortId : string;
  lastChangedAt : int;
  lastChangeUser : change_user option;
  userPath : user_path;
  teamPath : team_path option;
  readPermission : rw_permission;
  writePermission : rw_permission;
}
[@@deriving show]

let note_of_yojson yojson =
  let open Yojson.Safe.Util in
  let get_member_s field = to_string @@ member field yojson
  and get_member_i field = to_int @@ member field yojson
  and get_member_io field = to_int_option @@ member field yojson
  and get_list f field = List.map f @@ to_list @@ member field yojson
  and get_member_so field = to_string_option @@ member field yojson in
  {
    id = get_member_s "id";
    title = get_member_s "title";
    tags = get_list to_string "tags";
    createdAt = get_member_i "createdAt";
    publishType = get_member_s "publishType";
    publishedAt = get_member_io "publishedAt";
    permalink = get_member_so "permalink";
    shortId = get_member_s "shortId";
    lastChangedAt = get_member_i "lastChangedAt";
    lastChangeUser = change_user_of_yojson @@ member "lastChangeUser" yojson;
    userPath = get_member_s "userPath";
    teamPath = get_member_so "teamPath";
    readPermission = rw_permission_of_yojson @@ member "readPermission" yojson;
    writePermission = rw_permission_of_yojson @@ member "writePermission" yojson;
  }

let notes token =
  let open Combined_syntax in
  let++ body = get "notes" token in
  body |> Yojson.Safe.Util.to_list |> List.map note_of_yojson

let note token note_id =
  let open Combined_syntax in
  let++ body = get ("note/" ^ note_id) token in
  note_of_yojson body

let () = ignore comment_permission_of_yojson
