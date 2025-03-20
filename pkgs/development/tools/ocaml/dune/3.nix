{ lib, stdenv, fetchurl, ocaml, findlib, darwin, ocaml-lsp, dune-release }:

if lib.versionOlder ocaml.version "4.08"
then throw "dune 3 is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
  pname = "dune";
  version = "3.17.2";

  src = fetchurl {
    url = "https://github.com/ocaml/dune/releases/download/${version}/dune-${version}.tbz";
    hash = "sha256-ner+7Q7P6eZeZCzY5hl/CGT3P817lLWxma5NLgei6mQ=";
  };

  nativeBuildInputs = [ ocaml findlib ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.CoreServices
  ];

  strictDeps = true;

  buildFlags = [ "release" ];

  dontAddPrefix = true;
  dontAddStaticConfigureFlags = true;
  configurePlatforms = [];

  installFlags = [ "PREFIX=${placeholder "out"}" "LIBDIR=$(OCAMLFIND_DESTDIR)" ];

  passthru.tests = {
    inherit ocaml-lsp dune-release;
  };

  meta = {
    homepage = "https://dune.build/";
    description = "Composable build system";
    mainProgram = "dune";
    changelog = "https://github.com/ocaml/dune/raw/${version}/CHANGES.md";
    maintainers = [ lib.maintainers.vbgl ];
    license = lib.licenses.mit;
    inherit (ocaml.meta) platforms;
  };
}
