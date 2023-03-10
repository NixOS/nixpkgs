{ lib, stdenv, fetchurl, ocaml, findlib, ocamlbuild, ounit }:

let
  # ounit is only available for OCaml >= 4.04
  doCheck = lib.versionAtLeast ocaml.version "4.04";
in

stdenv.mkDerivation {
  pname = "ocamlmod";
  version = "0.0.9";

  src = fetchurl {
    url = "https://forge.ocamlcore.org/frs/download.php/1702/ocamlmod-0.0.9.tar.gz";
    sha256 = "0cgp9qqrq7ayyhddrmqmq1affvfqcn722qiakjq4dkywvp67h4aa";
  };

  strictDeps = !doCheck;

  nativeBuildInputs = [ ocaml findlib ocamlbuild ];

  configurePhase = "ocaml setup.ml -configure --prefix $out"
    + lib.optionalString doCheck " --enable-tests";
  buildPhase     = "ocaml setup.ml -build";
  installPhase   = "ocaml setup.ml -install";

  inherit doCheck;
  nativeCheckInputs = [ ounit ];

  checkPhase = "ocaml setup.ml -test";

  dontStrip = true;

  meta = {
    homepage = "https://forge.ocamlcore.org/projects/ocamlmod/ocamlmod";
    description = "Generate OCaml modules from source files";
    platforms = ocaml.meta.platforms or [];
    maintainers = with lib.maintainers; [
      maggesi
    ];
  };
}
