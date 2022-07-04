(** A wrapper around hackmd api *)

open Types_and_parser.V1

module V1 : sig
  type token
  type error = Cohttp_lwt_unix.Response.t * Cohttp_lwt.Body.t

  val token_of_string : string -> token
  val user : ?api_url:string -> token -> (user, error) result Lwt.t
  val note : ?api_url:string -> token -> note_id -> (note, error) result Lwt.t

  val notes :
    ?api_url:string -> token -> (note_summary list, error) result Lwt.t

  val teams : ?api_url:string -> token -> (team list, error) result Lwt.t

  val team_notes :
    ?api_url:string -> token -> team_path -> (note list, error) result Lwt.t

  val create_note :
    ?api_url:string -> token -> new_note option -> (note, error) result Lwt.t

  val update_note :
    ?api_url:string ->
    token ->
    note_id ->
    update_note option ->
    (string, error) result Lwt.t

  val delete_note :
    ?api_url:string -> token -> note_id -> (string, error) result Lwt.t

  val history :
    ?api_url:string -> token -> (note_summary list, error) result Lwt.t

  val create_note_in_team :
    ?api_url:string ->
    token ->
    team_path ->
    new_note option ->
    (note, error) result Lwt.t

  val update_note_in_team :
    ?api_url:string ->
    token ->
    team_path ->
    note_id ->
    update_note option ->
    (string, error) result Lwt.t

  val delete_note_in_team :
    ?api_url:string ->
    token ->
    team_path ->
    note_id ->
    (string, error) result Lwt.t
end
