{stdenv, fetchurl, ocaml, findlib, yojson, menhir}:
stdenv.mkDerivation {

  name = "merlin-1.7";

  src = fetchurl {
    url = "https://github.com/the-lambda-church/merlin/archive/v1.7.tar.gz";
    sha256 = "0grprrykah02g8va63lidbcb6n8sd18l2k9spb5rwlcs3xhfw42b";
  };

  buildInputs = [ ocaml findlib yojson menhir ];

  prefixKey = "--prefix ";

  meta = {
    description = "An editor-independant tool to ease the developpement of programs in OCaml";
    homepage = "http://the-lambda-church.github.io/merlin/";
    license = stdenv.lib.licenses.mit;
  };
}

