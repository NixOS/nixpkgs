{
  lib,
  fetchFromGitHub,
  buildGhidraExtension,
}:
buildGhidraExtension rec {
  pname = "lightkeeper";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "WorksButNotTested";
    repo = "lightkeeper";
    rev = version;
    hash = "sha256-4lj60OyVcam4JHyfIa+4auzITuEYqjz9wOQko/u+2dI=";
  };
  preConfigure = ''
    cd lightkeeper
  '';
  meta = {
    description = "A port of the Lighthouse plugin to GHIDRA.";
    homepage = "https://github.com/WorksButNotTested/lightkeeper";
    license = lib.licenses.asl20;
  };
}
