{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "material-you-utilities";
  version = "2.0.21";

  src = fetchFromGitHub {
    owner = "Nerwyn";
    repo = "material-you-utilities";
    tag = version;
    hash = "sha256-rGwa5vP0Wka9w1m4s6q8stqSe1QVu2US59/RnMOR8+A=";
  };

  npmDepsHash = "sha256-Coc8SOqc2tElx3HzzUsYxc+eKkdjkbROh8LvPB2Iro8=";

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
