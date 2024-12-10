{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "antennas";
  version = "4.2.0";

  src = fetchFromGitHub {
    owner = "jfarseneau";
    repo = "antennas";
    rev = "v${version}";
    hash = "sha256-UQ+wvm7+x/evmtGwzCkUkrrDMCIZzUL4iSkLmYKJ3Mc=";
  };

  npmDepsHash = "sha256-D5ss7nCDY3ogZy64iFqLVKbmibAg7C/A+rEHJaE9c2U=";

  dontNpmBuild = true;

  doCheck = true;

  checkPhase = ''
    runHook preCheck

    npm run test

    runHook postCheck
  '';

  meta = {
    description = "HDHomeRun emulator for Plex DVR to connect to Tvheadend";
    homepage = "https://github.com/jfarseneau/antennas";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bachp ];
    mainProgram = "antennas";
  };
}
