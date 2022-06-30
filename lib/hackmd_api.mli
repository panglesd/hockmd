(** A wrapper around hackmd api *)
module Result_syntax : sig
  val ( let* ) : ('a, 'b) result -> ('a -> ('c, 'b) result) -> ('c, 'b) result
  val ( let+ ) : ('a, 'b) result -> ('a -> 'c) -> ('c, 'b) result
end

module Combined_syntax : sig
  val ( let++ ) : ('a, 'b) result Lwt.t -> ('a -> 'c) -> ('c, 'b) result Lwt.t

  val ( let** ) :
    ('a, 'b) result Lwt.t ->
    ('a -> ('c, 'b) result Lwt.t) ->
    ('c, 'b) result Lwt.t

  val ( let*+ ) :
    ('a, 'b) result Lwt.t -> ('a -> 'c Lwt.t) -> ('c, 'b) result Lwt.t

  val ( let+* ) :
    ('a, 'b) result Lwt.t -> ('a -> ('c, 'b) result) -> ('c, 'b) result Lwt.t
end

type error
type user_id
type team_id
type user_path
type team_path

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

type user = {
  id : user_id;
  name : string;
  email : string option;
  userPath : string;
  photo : string;
  teams : team list;
}
[@@deriving show]

type note_id [@@deriving show]
type publish_type = string (* View, ... *) [@@deriving show]
type rw_permission = Owner | Signed_in | Guest [@@deriving show]

type comment_permission =
  | Disabled
  | Forbidden
  | Owners
  | Signed_in_users
  | Everyone[@@deriving show]

type change_user = {
  name : string;
  photo : string;
  biography : string option;
  userPath : user_path;
}[@@deriving show]

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
}[@@deriving show]

val greet : string -> string
(** Returns a greeting message.

    {4 Examples}

    {[
      print_endline @@ greet "Jane"
    ]} *)

val f : unit -> (unit, error) result Lwt.t
val user : string -> (user, error) result Lwt.t
val note : string -> string -> (note, error) result Lwt.t
val notes : string -> (note list, error) result Lwt.t
