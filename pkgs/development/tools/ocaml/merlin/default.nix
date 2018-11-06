{ stdenv, fetchzip, ocaml, findlib, dune, yojson }:

assert stdenv.lib.versionAtLeast ocaml.version "4.02";

let
  version = "3.2.2";
in

stdenv.mkDerivation {

  name = "merlin-${version}";

  src = fetchzip {
    url = "https://github.com/ocaml/merlin/archive/v${version}.tar.gz";
    sha256 = "15ssgmwdxylbwhld9p1cq8x6kadxyhll5bfyf11dddj6cldna3hb";
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
