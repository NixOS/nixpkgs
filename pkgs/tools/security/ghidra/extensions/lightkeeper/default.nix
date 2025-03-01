{
  lib,
  fetchFromGitHub,
  buildGhidraExtension,
}:
buildGhidraExtension rec {
  pname = "lightkeeper";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "WorksButNotTested";
    repo = "lightkeeper";
    rev = version;
    hash = "sha256-HPRFdoNjVh7MUneJeccXQ3sloGHkpVuMZwjtFI5wd9I=";
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
