(** A wrapper around hackmd api *)

type error

open Types_and_parser.V1

module V1 : sig
  type token

  val token_of_string : string -> token
  val user : token -> (user, error) result Lwt.t
  val note : token -> string -> (note, error) result Lwt.t
  val notes : token -> (note_summary list, error) result Lwt.t
  val teams : token -> (team list, error) result Lwt.t
  val team_notes : token -> team_path -> (note list, error) result Lwt.t
  val create_note : token -> new_note option -> (note, error) result Lwt.t

  val update_note :
    token -> note_id -> update_note option -> (string, error) result Lwt.t

  val delete_note : token -> note_id -> (string, error) result Lwt.t
  val history : token -> (note_summary list, error) result Lwt.t

  val create_note_in_team :
    token -> team_path -> new_note option -> (note, error) result Lwt.t

  val update_note_in_team :
    token ->
    team_path ->
    note_id ->
    update_note option ->
    (string, error) result Lwt.t

  val delete_note_in_team :
    token -> team_path -> note_id -> (string, error) result Lwt.t
end
