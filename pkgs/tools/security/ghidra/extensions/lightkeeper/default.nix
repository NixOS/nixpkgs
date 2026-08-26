{
  lib,
  fetchFromGitHub,
  buildGhidraExtension,
}:
buildGhidraExtension (finalAttrs: {
  pname = "lightkeeper";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "WorksButNotTested";
    repo = "lightkeeper";
    rev = finalAttrs.version;
    hash = "sha256-LfRrduGLdt5NDzNGBUCBYcZChamzjtY8tMBvXitoH58=";
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
