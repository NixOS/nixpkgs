{ lib, stdenv, fetchurl, ocaml, findlib }:

if lib.versionOlder ocaml.version "4.08"
then throw "dune is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
  pname = "dune";
  version = "2.8.5";

  src = fetchurl {
    url = "https://github.com/ocaml/dune/releases/download/${version}/dune-${version}.tbz";
    sha256 = "0a9n8ilsi3kyx5xqvk5s7iikk6y3pkpm5mvsn5za5ivlzf1i40br";
  };

  buildInputs = [ ocaml findlib ];

  buildFlags = "release";

  dontAddPrefix = true;

  installFlags = [ "PREFIX=${placeholder "out"}" "LIBDIR=$(OCAMLFIND_DESTDIR)" ];

  meta = {
    homepage = "https://dune.build/";
    description = "A composable build system";
    changelog = "https://github.com/ocaml/dune/blob/${version}/CHANGES.md";
    maintainers = [ lib.maintainers.vbgl lib.maintainers.marsam ];
    license = lib.licenses.mit;
    inherit (ocaml.meta) platforms;
  };
}
