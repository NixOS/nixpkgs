{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "material-you-utilities";
  version = "2.0.12";

  src = fetchFromGitHub {
    owner = "Nerwyn";
    repo = "material-you-utilities";
    tag = version;
    hash = "sha256-R93jv6r6pEe/2t+2RntMzykvH/tNikm79mWYyYnfgyk=";
  };

  npmDepsHash = "sha256-xSlEkYqeq0DLttwlqYKh02B6nW96aENC6C6cuIQCInU=";

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
