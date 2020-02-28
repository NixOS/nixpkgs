{ stdenv, fetchurl, ocaml, findlib }:

if stdenv.lib.versionOlder ocaml.version "4.07"
then throw "dune is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
  pname = "dune";
  version = "2.3.1";

  src = fetchurl {
    url = "https://github.com/ocaml/dune/releases/download/${version}/dune-${version}.tbz";
    sha256 = "1jzm29z58l34kpqll9jcz5dkkhh36lncba1yb32ghknkvyfdvcxj";
  };

  buildInputs = [ ocaml findlib ];

  buildFlags = "release";

  dontAddPrefix = true;

  installFlags = [ "PREFIX=${placeholder "out"}" "LIBDIR=$(OCAMLFIND_DESTDIR)" ];

  meta = {
    homepage = "https://dune.build/";
    description = "A composable build system";
    changelog = "https://github.com/ocaml/dune/releases/tag/${version}";
    maintainers = [ stdenv.lib.maintainers.vbgl stdenv.lib.maintainers.marsam ];
    license = stdenv.lib.licenses.mit;
    inherit (ocaml.meta) platforms;
  };
}
