{
  lib,
  fetchFromGitHub,
  buildGhidraExtension,
}:
buildGhidraExtension (finalAttrs: {
  pname = "lightkeeper";
  version = "1.2.4";

  src = fetchFromGitHub {
    owner = "WorksButNotTested";
    repo = "lightkeeper";
    rev = finalAttrs.version;
    hash = "sha256-aGMWg6VQleKH/txlxpSw19QOotWZSqeW5Ve2SpWGhgA=";
  };
  preConfigure = ''
    cd lightkeeper
  '';
  meta = {
    description = "A port of the Lighthouse plugin to GHIDRA.";
    homepage = "https://github.com/WorksButNotTested/lightkeeper";
    license = lib.licenses.asl20;
  };
})
