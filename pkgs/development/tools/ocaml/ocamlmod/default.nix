{
  lib,
  ocaml,
  buildDunePackage,
  fetchurl,
  ounit2,
}:

buildDunePackage (finalAttrs: {
  pname = "ocamlmod";
  version = "0.1.1";

  minimalOCamlVersion = "4.03";

  src = fetchurl {
    url = "https://github.com/gildor478/ocamlmod/releases/download/v${finalAttrs.version}/ocamlmod-${finalAttrs.version}.tbz";
    hash = "sha256-qMG+y/iS+L4qtKiJX01pTTAdQuGLoIA+so1fqY9bm8o=";
  };

  doCheck = lib.versionAtLeast ocaml.version "4.08";
  checkInputs = [ ounit2 ];

  dontStrip = true;

  meta = {
    homepage = "https://github.com/gildor478/ocamlmod";
    description = "Generate OCaml modules from source files";
    maintainers = with lib.maintainers; [
      maggesi
    ];
    mainProgram = "ocamlmod";
  };
})
