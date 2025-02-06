{
  lib,
  fetchFromGitHub,
  buildGhidraExtension,
}:
buildGhidraExtension rec {
  pname = "lightkeeper";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "WorksButNotTested";
    repo = "lightkeeper";
    rev = version;
    hash = "sha256-9BkI3sY/x0SwODwq646WBqU05wnfu/bU4lUfyRQV7UA=";
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
