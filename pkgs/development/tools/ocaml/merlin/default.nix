{ stdenv, fetchzip, ocaml, findlib, dune, yojson }:

assert stdenv.lib.versionAtLeast ocaml.version "4.02";

let
  version = "3.2.1";
in

stdenv.mkDerivation {

  name = "merlin-${version}";

  src = fetchzip {
    url = "https://github.com/ocaml/merlin/archive/v${version}.tar.gz";
    sha256 = "1szv2b7d12ll5n6pvnhlv3a6vnlyrkpya4l9fiyyiwyvgd4xzxwf";
  };

  buildInputs = [ ocaml findlib dune yojson ];

  inherit (dune) installPhase;

  meta = with stdenv.lib; {
    description = "An editor-independent tool to ease the development of programs in OCaml";
    homepage = "https://github.com/ocaml/merlin";
    license = licenses.mit;
    maintainers = [ maintainers.vbgl ];
  };
}
