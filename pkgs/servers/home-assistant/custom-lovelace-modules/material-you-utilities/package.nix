{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "material-you-utilities";
  version = "2.0.34";

  src = fetchFromGitHub {
    owner = "Nerwyn";
    repo = "material-you-utilities";
    tag = version;
    hash = "sha256-g3ooB83OPAKv8M4T237p7vfvqA75UItkrqU4rWsv6HU=";
  };

  npmDepsHash = "sha256-oMDSZMy2vg1vBDJUDVqhqNSmgbN7j5mdJIc/Bjbeiao=";

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp dist/material-you-utilities.min.js $out/

    runHook postInstall
  '';

  passthru.entrypoint = "material-you-utilities.min.js";

  meta = {
    description = "Material Design 3 color theme generation and Home Assistant component modification";
    homepage = "https://github.com/Nerwyn/material-you-utilities";
    changelog = "https://github.com/Nerwyn/material-you-utilities/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
