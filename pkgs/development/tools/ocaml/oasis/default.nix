{ lib, stdenv, fetchurl, ocaml, findlib, ocamlbuild, ocamlmod, ocamlify }:

stdenv.mkDerivation {
  version = "0.4.11";
  pname = "ocaml-oasis";

  src = fetchurl {
    url = "https://download.ocamlcore.org/oasis/oasis/0.4.11/oasis-0.4.11.tar.gz";
    hash = "sha256-GLc97vTtbpqDM38ks7vi3tZSaLP/cwn8wA0l5X4dwS4=";
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
    homepage = "https://github.com/ocaml/oasis";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ vbgl maggesi ];
    mainProgram = "oasis";
    inherit (ocaml.meta) platforms;
  };
}
