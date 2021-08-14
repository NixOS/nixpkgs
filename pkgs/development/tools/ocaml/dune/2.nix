{ lib, stdenv, fetchurl, ocaml, findlib }:

if lib.versionOlder ocaml.version "4.08"
then throw "dune 2 is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
  pname = "dune";
  version = "2.9.0";

  src = fetchurl {
    url = "https://github.com/ocaml/dune/releases/download/${version}/dune-${version}.tbz";
    sha256 = "07m476kgagpd6kzm3jq30yfxqspr2hychah0xfqs14z82zxpq8dv";
  };

  nativeBuildInputs = [ ocaml findlib ];
  strictDeps = true;

  buildFlags = "release";

  dontAddPrefix = true;
  dontAddStaticConfigureFlags = true;
  configurePlatforms = [];

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
