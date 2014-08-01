{ stdenv, fetchurl, ocaml, findlib, menhir, yojson }:

stdenv.mkDerivation {
  name = "merlin-1.6";

  src = fetchurl {
    url = https://github.com/the-lambda-church/merlin/archive/v1.6.tar.gz;
    sha256 = "0wq75hgffaszazrhkl0nfjxgx8bvazi2sjannd8q64hvax8hxzcy";
  };

  createFindlibDestdir = true;

  prefixKey = "--prefix ";

  buildInputs = [ ocaml findlib menhir yojson ];

  meta = {
    homepage = https://the-lambda-church.github.io/merlin;
    description = "An assistant for editing OCaml code";
    license = stdenv.lib.licenses.mit;
    platforms = ocaml.meta.platforms;
    maintainers = with stdenv.lib.maintainers; [ gal_bolle ];
  };

}
