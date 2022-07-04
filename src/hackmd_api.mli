(** This library is a wrapper around
    {{:https://hackmd.io\@hackmd-api/developer-portal} hackmd API}.

    It provides a module for each version of the protocol, that is currently
    only the module {!V1} to speak the first version of the protocol. *)

module V1 : sig
  (** The first version of the protocol is described
      {{:https://hackmd.io\@hackmd-api/developer-portal} here}. However, it is
      not exactly clear in the document which field are optional and which are
      not optional. So, until a solid testing has been done, the API will be
      subject to changes.

      The module {!Types} contains all types, bith for requests and responses.

      Other values of this module straightforwardly corresponds to a method of
      the protocol. *)
  module Types : sig
    type user_id
    (** Type for the users id *)

    type team_id
    (** Type for the teams id *)

    type user_path
    (** Another way to reference users, used by some functions *)

    type team_path
    (** Another way to reference teams, used by some functions *)

    type team = {
      id : team_id;
      ownerId : user_id;
      path : team_path;
      name : string;
      logo : string;
      description : string;
      visibility : string;
      createdAt : int;
    }
    (** The type for teams *)

    type user = {
      id : user_id;
      name : string;
      email : string option;
      userPath : string;
      photo : string;
      teams : team list;
    }
    (** The type for users *)

    type note_id

    type publish_type = string
    (** How the published document open, for instance ["view"]. Will change
        shortly to a variant type. *)

    (** Used to designate who can read, or who can write. *)
    type rw_permission = Owner | Signed_in | Guest

    (** Used to specify comment permission. *)
    type comment_permission =
      | Disabled
      | Forbidden
      | Owners
      | Signed_in_users
      | Everyone

    type change_user = {
      name : string;
      photo : string;
      biography : string option;
      userPath : user_path;
    }
    (** Fewer information on a user, used on some fields such as {!type-note}
        and {!type-note_summary} . *)

    type note_summary = {
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
    (** Information on a note, without including the content. Used when querying
        the list of notes. *)

    type note = {
      id : note_id;
      title : string;
      tags : string list;
      createdAt : int;
      publishType : publish_type;
      publishedAt : int option;
      permalink : string option;
      shortId : string;
      content : string;
      lastChangedAt : int;
      lastChangeUser : change_user option;
      userPath : user_path;
      teamPath : team_path option;
      readPermission : rw_permission;
      writePermission : rw_permission;
    }
    (** All information on a note, including its content. *)

    type new_note = {
      title : string;
      content : string;
      readPermission : rw_permission;
      writePermission : rw_permission;
      commentPermission : comment_permission;
    }
    (** Type used to create a new note, see {{!Hackmd_api.V1.create_note}
        [create_note]}. *)

    type update_note = { content : string; readPermission : rw_permission }
    (** Type used to update a note, see {{!Hackmd_api.V1.update_note}
        [update_note]}. *)
  end

  open Types

  type token
  type error = Cohttp_lwt_unix.Response.t * Cohttp_lwt.Body.t

  val token_of_string : string -> token
  (** A token, generated as explained
      {{:https://hackmd.io\@hackmd-api/developer-portal/https%3A%2F%2Fhackmd.io%2F%40hackmd-api%2Fhow-to-issue-an-api-token}
      here}, to authenticate yourself. *)

  (** In all what follows, [api_url] is the url of the [api] server, which
      defaults to [https://api.hackmd.io]. *)

  val user : ?api_url:string -> token -> (user, error) result Lwt.t
  (** To get the information on the user associated with the [token] *)

  val note : ?api_url:string -> token -> note_id -> (note, error) result Lwt.t
  (** To get the information on the note of id [note_id]. *)

  val notes :
    ?api_url:string -> token -> (note_summary list, error) result Lwt.t
  (** To get the list of notes of the user corresponding to [token]. Note that
      the notes won't include their content, as they are given as
      {!Types.note_summary}. *)

  val teams : ?api_url:string -> token -> (team list, error) result Lwt.t
  (** To get the list of the teams of the user corresponding to [token]. *)

  val team_notes :
    ?api_url:string -> token -> team_path -> (note list, error) result Lwt.t
  (** To get the list notes of the teams of the user corresponding to [token]. *)

  val create_note :
    ?api_url:string -> token -> new_note option -> (note, error) result Lwt.t
  (** To create a note. If [None] is provided, an empty note is created. *)

  val update_note :
    ?api_url:string ->
    token ->
    note_id ->
    update_note option ->
    (string, error) result Lwt.t
  (** To update a note. If [None] is provided, consult the
      {{:https://hackmd.io\@hackmd-api/developer-portal} API} as I am not sure
      what it does. *)

  val delete_note :
    ?api_url:string -> token -> note_id -> (string, error) result Lwt.t
  (** To delete a note. *)

  val history :
    ?api_url:string -> token -> (note_summary list, error) result Lwt.t
  (** To get the history of read notes. *)

  val create_note_in_team :
    ?api_url:string ->
    token ->
    team_path ->
    new_note option ->
    (note, error) result Lwt.t
  (** To create a note in a team workspace. If [None] is provided, an empty note
      is created. *)

  val update_note_in_team :
    ?api_url:string ->
    token ->
    team_path ->
    note_id ->
    update_note option ->
    (string, error) result Lwt.t
  (** To update a note in a team workspace. If [None] is provided, see
      {{:https://hackmd.io\@hackmd-api/developer-portal} official API} *)

  val delete_note_in_team :
    ?api_url:string ->
    token ->
    team_path ->
    note_id ->
    (string, error) result Lwt.t
  (** To delete a note in a team workspace. *)
end
