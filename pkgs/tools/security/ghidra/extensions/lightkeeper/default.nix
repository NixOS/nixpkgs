{
  lib,
  fetchFromGitHub,
  buildGhidraExtension,
}:
buildGhidraExtension rec {
  pname = "lightkeeper";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "WorksButNotTested";
    repo = "lightkeeper";
    rev = version;
    hash = "sha256-Emyo4GBrR725jDxRsStC6/4F9mYnRo3S3QY0GeB/BvI=";
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
