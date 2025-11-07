{
  lib,
  stdenv,
  fetchurl,
  ocaml,
  findlib,
}:

if lib.versionOlder ocaml.version "4.08" then
  throw "dune 2 is not available for OCaml ${ocaml.version}"
else

  stdenv.mkDerivation rec {
    pname = "dune";
    version = "2.9.3";

    src = fetchurl {
      url = "https://github.com/ocaml/dune/releases/download/${version}/dune-site-${version}.tbz";
      sha256 = "sha256:1ml8bxym8sdfz25bx947al7cvsi2zg5lcv7x9w6xb01cmdryqr9y";
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
