{
  lib,
  fetchFromGitHub,
  buildGhidraExtension,
}:
buildGhidraExtension (finalAttrs: {
  pname = "lightkeeper";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "WorksButNotTested";
    repo = "lightkeeper";
    rev = finalAttrs.version;
    hash = "sha256-iwQA31FUr9pVnqyG29k455024R5uPfIMmN7EY3XfzOU=";
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
