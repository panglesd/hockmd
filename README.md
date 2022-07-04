# hockmd

An ocaml library to access the hackmd API.

## Installation

### Using Opam

```bash
opam install hockmd
```

## Usage

The [API](https://panglesd.github.io/hockmd/hockmd/Hockmd/index.html) of the library follows closely the one of the [hackmd API](https://hackmd.io\@hackmd-api/developer-portal/https%3A%2F%2Fhackmd.io%2F%40hackmd-api%2Fhow-to-issue-an-api-token).

You will need a token as explained [here](https://hackmd.io/@hackmd-api/developer-portal/https%3A%2F%2Fhackmd.io%2F%40hackmd-api%2Fhow-to-issue-an-api-token).

The library returns types enclosed in `result` and `promises`. It is advised to make use of ocaml syntax to avoid a too heavy syntax!

``` ocaml

let token = "........."

let res =
    let++ notes = Hockmd.notes token in
    List.iter (fun note -> print_endline note.title) notes

```
