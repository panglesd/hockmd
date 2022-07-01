(** A wrapper around hackmd api *)

module V1 : sig
  module Types : sig
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

    type user = {
      id : user_id;
      name : string;
      email : string option;
      userPath : string;
      photo : string;
      teams : team list;
    }

    type note_id
    type publish_type = string (* View, ... *)
    type rw_permission = Owner | Signed_in | Guest

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

    type new_note = {
      title : string;
      content : string;
      readPermission : rw_permission;
      writePermission : rw_permission;
      commentPermission : comment_permission;
    }

    type update_note = { content : string; readPermission : rw_permission }
  end

  include module type of Api.V1
  (** @inline *)
end
