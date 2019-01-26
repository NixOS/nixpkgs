{ stdenv, fetchFromGitHub, ocaml, findlib, dune, ocp-build, ocp-indent, cmdliner, re }:

stdenv.mkDerivation rec {

  version = "1.1.7";
  name = "ocaml${ocaml.version}-ocp-index-${version}";

  src = fetchFromGitHub {
    owner = "OCamlPro";
    repo = "ocp-index";
    rev = version;
    sha256 = "0i50y033y78wcfgz3b81d34p98azahl94w4b63ac0zyczlwlhvkf";
  };

  buildInputs = [ ocaml findlib dune ocp-build cmdliner re ];
  propagatedBuildInputs = [ ocp-indent ];

  buildPhase = "dune build -p ocp-index";

  inherit (dune) installPhase;

  meta = {
    homepage = http://typerex.ocamlpro.com/ocp-index.html;
    description = "A simple and light-weight documentation extractor for OCaml";
    license = stdenv.lib.licenses.lgpl3;
    platforms = ocaml.meta.platforms or [];
    maintainers = with stdenv.lib.maintainers; [ vbgl ];
  };
}
