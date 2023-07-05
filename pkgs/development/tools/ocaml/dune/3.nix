{ lib, stdenv, fetchurl, ocaml, findlib, darwin, ocaml-lsp }:

if lib.versionOlder ocaml.version "4.08"
then throw "dune 3 is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
  pname = "dune";
  version = "3.9.0";

  src = fetchurl {
    url = "https://github.com/ocaml/dune/releases/download/${version}/dune-${version}.tbz";
    hash = "sha256-xIJaneRUrt9FDC2yWsNTAz4x0yap0bS3os1yYGOb1UQ=";
  };

  nativeBuildInputs = [ ocaml findlib ];

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreServices
  ];

  strictDeps = true;

  buildFlags = [ "release" ];

  dontAddPrefix = true;
  dontAddStaticConfigureFlags = true;
  configurePlatforms = [];

  installFlags = [ "PREFIX=${placeholder "out"}" "LIBDIR=$(OCAMLFIND_DESTDIR)" ];

  passthru.tests = {
    inherit ocaml-lsp;
  };

  meta = {
    homepage = "https://dune.build/";
    description = "A composable build system";
    changelog = "https://github.com/ocaml/dune/raw/${version}/CHANGES.md";
    maintainers = [ lib.maintainers.vbgl lib.maintainers.marsam ];
    license = lib.licenses.mit;
    inherit (ocaml.meta) platforms;
  };
}
