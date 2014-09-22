{stdenv, fetchurl, ocaml, findlib, yojson, menhir}:

assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ocaml) "4.00";

stdenv.mkDerivation {

  name = "merlin-1.7.1";

  src = fetchurl {
    url = https://github.com/the-lambda-church/merlin/archive/v1.7.1.tar.gz;
    sha256 = "c3b60c7b3fddaa2860e0d8ac0d4fed2ed60e319875734c7ac1a93df524c67aff";
  };

  buildInputs = [ ocaml findlib yojson menhir ];

  prefixKey = "--prefix ";

  meta = with stdenv.lib; {
    description = "An editor-independent tool to ease the development of programs in OCaml";
    homepage = "http://the-lambda-church.github.io/merlin/";
    license = licenses.mit;
    maintainers = [ maintainers.vbgl ];
  };
}
