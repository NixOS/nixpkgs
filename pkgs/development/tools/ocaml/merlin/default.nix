{stdenv, fetchurl, ocaml, findlib, easy-format, biniou, yojson, menhir}:
stdenv.mkDerivation {

  name = "merlin-1.6";

  src = fetchurl {
    url = "https://github.com/the-lambda-church/merlin/archive/v1.6.tar.gz";
    sha256 = "0wq75hgffaszazrhkl0nfjxgx8bvazi2sjannd8q64hvax8hxzcy";
  };

  buildInputs = [ ocaml findlib biniou yojson menhir easy-format ];

  prefixKey = "--prefix ";

  meta = {
    description = "An editor-independant tool to ease the developpement of programs in OCaml";
    homepage = "http://the-lambda-church.github.io/merlin/";
    license = stdenv.lib.licenses.mit;
  };
}

