module V1 : sig
  type user_id = string [@@deriving show, yojson]
  type team_id [@@deriving show, yojson]
  type user_path [@@deriving show, yojson]
  type team_path [@@deriving show, yojson]

  val string_of_team_path : team_path -> string

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
  [@@deriving show, yojson]

  type user = {
    id : user_id;
    name : string;
    email : string option;
    userPath : string;
    photo : string;
    teams : team list;
  }
  [@@deriving show, yojson]

  type note_id = string [@@deriving show, yojson]

  val string_of_note_id : note_id -> string

  type publish_type = string (* View, ... *) [@@deriving show, yojson]
  type rw_permission = Owner | Signed_in | Guest [@@deriving show, yojson]

  type comment_permission =
    | Disabled
    | Forbidden
    | Owners
    | Signed_in_users
    | Everyone
  [@@deriving show, yojson]

  type change_user = {
    name : string;
    photo : string;
    biography : string option;
    userPath : user_path;
  }
  [@@deriving show, yojson]

  type note_summary = {
    id : note_id;
    title : string;
    tags : string list;
    createdAt : int;
    publishType : publish_type;
    publishedAt : int option;
    permalink : string option;
    publishLink : string;
    shortId : string;
    lastChangedAt : int;
    lastChangeUser : change_user option;
    userPath : user_path;
    teamPath : team_path option;
    readPermission : rw_permission;
    writePermission : rw_permission;
  }
  [@@deriving show, yojson]

  type note = {
    id : note_id;
    title : string;
    tags : string list;
    createdAt : int;
    publishType : publish_type;
    publishedAt : int option;
    permalink : string option;
    publishLink : string;
    shortId : string;
    content : string;
    lastChangedAt : int;
    lastChangeUser : change_user option;
    userPath : user_path;
    teamPath : team_path option;
    readPermission : rw_permission;
    writePermission : rw_permission;
  }
  [@@deriving show, yojson]

  type new_note = {
    title : string;
    content : string;
    readPermission : rw_permission;
    writePermission : rw_permission;
    commentPermission : comment_permission;
  }
  [@@deriving show, yojson]

  type update_note = { content : string; readPermission : rw_permission option }
  [@@deriving show, yojson]
end
