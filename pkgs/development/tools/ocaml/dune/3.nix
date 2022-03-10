{ lib, stdenv, fetchurl, ocaml, findlib, darwin }:

if lib.versionOlder ocaml.version "4.08"
then throw "dune 3 is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
  pname = "dune";
  version = "3.0.2";

  src = fetchurl {
    url = "https://github.com/ocaml/dune/releases/download/${version}/fiber-${version}.tbz";
    sha256 = "sha256-o108qIeWMOX0VU/wWdc5bg/UDCT2CCcw/Xx3nFiDbes=";
  };

  nativeBuildInputs = [ ocaml findlib ];

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Foundation
  ];

  strictDeps = true;

  buildFlags = "release";

  dontAddPrefix = true;
  dontAddStaticConfigureFlags = true;
  configurePlatforms = [];

  installFlags = [ "PREFIX=${placeholder "out"}" "LIBDIR=$(OCAMLFIND_DESTDIR)" ];

  meta = {
    homepage = "https://dune.build/";
    description = "A composable build system";
    changelog = "https://github.com/ocaml/dune/raw/${version}/CHANGES.md";
    maintainers = [ lib.maintainers.vbgl lib.maintainers.marsam ];
    license = lib.licenses.mit;
    inherit (ocaml.meta) platforms;
  };
}
