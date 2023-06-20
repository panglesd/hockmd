module V1 = struct
  type user_id = string [@@deriving show, yojson]
  type team_id = string [@@deriving show, yojson]
  type user_path = string [@@deriving show, yojson]
  type team_path = string [@@deriving show, yojson]

  let string_of_team_path a = a

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
  [@@deriving show, yojson] [@@yojson.allow_extra_fields]

  type user = {
    id : user_id;
    name : string;
    email : string option;
    userPath : string;
    photo : string;
    teams : team list;
  }
  [@@deriving show, yojson] [@@yojson.allow_extra_fields]

  type note_id = string [@@deriving show, yojson]

  let string_of_note_id = Fun.id

  type publish_type = string (* View, ... *) [@@deriving show, yojson]
  type rw_permission = Owner | Signed_in | Guest [@@deriving show]

  let rw_permission_of_yojson yojson =
    match yojson with
    | `String "owner" -> Owner
    | `String "signed_in" -> Signed_in
    | `String "guest" -> Guest
    | _ -> failwith "TODO"

  let yojson_of_rw_permission rw_perm =
    match rw_perm with
    | Owner -> `String "owner"
    | Signed_in -> `String "signed_in"
    | Guest -> `String "guest"

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
  [@@deriving show, yojson] [@@yojson.allow_extra_fields]

  type note_summary = {
    id : note_id;
    title : string;
    tags : string list;
    createdAt : int option;
    publishType : publish_type;
    publishedAt : int option;
    permalink : string option;
    publishLink : string;
    shortId : string;
    lastChangedAt : int option;
    lastChangeUser : change_user option;
    userPath : user_path;
    teamPath : team_path option;
    readPermission : rw_permission;
    writePermission : rw_permission;
    titleUpdatedAt : int option;
    tagsUpdatedAt : int option;
  }
  [@@deriving show, yojson] [@@yojson.allow_extra_fields]

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
    titleUpdatedAt : int option;
    tagsUpdatedAt : int option;
  }
  [@@deriving show, yojson] [@@yojson.allow_extra_fields]

  type new_note = {
    title : string;
    content : string;
    readPermission : rw_permission;
    writePermission : rw_permission;
    commentPermission : comment_permission;
  }
  [@@deriving show, yojson] [@@yojson.allow_extra_fields]

  type update_note = {
    content : string;
    readPermission : rw_permission option; [@yojson.option]
  }
  [@@deriving show, yojson] [@@yojson.allow_extra_fields]
end
