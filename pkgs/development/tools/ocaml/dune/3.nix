{
  lib,
  stdenv,
  fetchurl,
  ocaml,
  findlib,
  ocaml-lsp,
  dune-release,
}:

if lib.versionOlder ocaml.version "4.08" then
  throw "dune 3 is not available for OCaml ${ocaml.version}"
else

  stdenv.mkDerivation rec {
    pname = "dune";
    version = "3.20.2";

    src = fetchurl {
      url = "https://github.com/ocaml/dune/releases/download/${version}/dune-${version}.tbz";
      hash = "sha256-sahrLWC9tKi5u2hhvfL58opufLXYM86Br+zOue+cpUk=";
    };

    nativeBuildInputs = [
      ocaml
      findlib
    ];

    strictDeps = true;

    buildFlags = [ "release" ];

    dontAddPrefix = true;
    dontAddStaticConfigureFlags = true;
    configurePlatforms = [ ];

    installFlags = [
      "PREFIX=${placeholder "out"}"
      "LIBDIR=$(OCAMLFIND_DESTDIR)"
    ];

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
