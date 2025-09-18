{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "material-you-utilities";
  version = "2.0.13";

  src = fetchFromGitHub {
    owner = "Nerwyn";
    repo = "material-you-utilities";
    tag = version;
    hash = "sha256-+eZHgdoPORFEcm8rP556J+G/T4n/BMy6dJXr+TOhgRU=";
  };

  npmDepsHash = "sha256-ZxQh3RXFlwBxKj5/AHZ4cPIL1HY2TUX+cSebgpeT+pk=";

  postPatch = ''
    # Remove git dependency from rspack config
    substituteInPlace rspack.config.js \
      --replace-fail "execSync('git branch --show-current').toString().trim() == 'main'" "false"
  '';

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
