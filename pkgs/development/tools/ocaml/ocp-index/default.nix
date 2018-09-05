{ stdenv, fetchFromGitHub, ocaml, findlib, dune, ocp-build, ocp-indent, cmdliner, re }:

stdenv.mkDerivation rec {

  version = "1.1.6";
  name = "ocaml${ocaml.version}-ocp-index-${version}";

  src = fetchFromGitHub {
    owner = "OCamlPro";
    repo = "ocp-index";
    rev = version;
    sha256 = "0p367aphz9w71qbm3y47qwhgqmyai28l96i1ifb6kg7awph5qmj3";
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
