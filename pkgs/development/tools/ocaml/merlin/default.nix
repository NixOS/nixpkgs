{stdenv, fetchurl, ocaml, findlib, easy-format, biniou, yojson, menhir}:
let
  pname = "merlin";
  version = "1.6";
  webpage = "http://the-lambda-church.github.io/merlin/";
in
stdenv.mkDerivation {

  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://github.com/the-lambda-church/${pname}/archive/v${version}.tar.gz";
    sha256 = "0wq75hgffaszazrhkl0nfjxgx8bvazi2sjannd8q64hvax8hxzcy";
  };

  buildInputs = [ ocaml findlib biniou yojson menhir easy-format ];

  prefixKey = "--prefix ";

  meta = {
    description = "An editor-independant tool to ease the developpement of programs in OCaml";
    homepage = "${webpage}";
    license = stdenv.lib.licenses.mit;
  };
}

