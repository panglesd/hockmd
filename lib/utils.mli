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
