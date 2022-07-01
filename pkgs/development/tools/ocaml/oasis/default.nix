{ lib, stdenv, fetchurl, ocaml, findlib, ocamlbuild, ocamlmod, ocamlify }:

stdenv.mkDerivation {
  version = "0.4.10";
  pname = "ocaml-oasis";

  # You must manually update the url, not just the version. OCamlforge keys off
  # the number after download.php, not the filename.
  src = fetchurl {
    url = "https://forge.ocamlcore.org/frs/download.php/1694/oasis-0.4.10.tar.gz";
    sha256 = "13ah03pbcvrjv5lmx971hvkm9rvbvimska5wmjfvgvd20ca0gn8w";
  };

  createFindlibDestdir = true;

  strictDeps = true;

  nativeBuildInputs =
    [
      ocaml findlib ocamlbuild ocamlmod ocamlify
    ];

  buildInputs = [ ocamlbuild ];

  configurePhase = ''
    runHook preConfigure
    ocaml setup.ml -configure --prefix $out
    runHook postConfigure
  '';
  buildPhase = ''
    runHook preBuild
    ocaml setup.ml -build
    runHook postBuild
  '';
  installPhase = ''
    runHook preInstall
    ocaml setup.ml -install
    runHook postInstall
  '';

  meta = with lib; {
    description = "Configure, build and install system for OCaml projects";
    homepage = "http://oasis.forge.ocamlcore.org/";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ vbgl maggesi ];
    mainProgram = "oasis";
    platforms = ocaml.meta.platforms or [];
  };
}
