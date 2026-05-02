{
  lib,
  fetchFromGitHub,
  buildGhidraExtension,
}:
buildGhidraExtension (finalAttrs: {
  pname = "lightkeeper";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "WorksButNotTested";
    repo = "lightkeeper";
    rev = finalAttrs.version;
    hash = "sha256-8ZJAzL5/9ssBo9d48lkwso8g6yshsVLMHYLPG/b9Mb0=";
  };
  preConfigure = ''
    cd lightkeeper
  '';
  meta = {
    description = "Port of the Lighthouse plugin to GHIDRA";
    homepage = "https://github.com/WorksButNotTested/lightkeeper";
    license = lib.licenses.asl20;
  };
})
