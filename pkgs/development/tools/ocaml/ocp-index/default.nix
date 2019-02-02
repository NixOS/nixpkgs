{ stdenv, fetchFromGitHub, ocaml, findlib, dune, ocp-build, ocp-indent, cmdliner, re }:

stdenv.mkDerivation rec {

  version = "1.1.8";
  name = "ocaml${ocaml.version}-ocp-index-${version}";

  src = fetchFromGitHub {
    owner = "OCamlPro";
    repo = "ocp-index";
    rev = version;
    sha256 = "0hfiwqi60xnwsmj7fmv1sk2gzr6wxdzbgd5zli2xnfrjvb4ydv12";
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
