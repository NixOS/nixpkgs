{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "swipe-navigation";
  version = "1.15.6";

  src = fetchFromGitHub {
    owner = "zanna-37";
    repo = "hass-swipe-navigation";
    tag = "v${version}";
    hash = "sha256-4DiZ52YFgyddD299rAMzBbmFNyv0SHEFK5H7kWRdWlw=";
  };

  npmDepsHash = "sha256-uRH3OcPK0iWru4ULZq2NwzbWNsGl8+wFP3ZxeFzr2BM=";

  buildPhase = ''
    runHook preBuild

    npx rollup --config

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp dist/swipe-navigation.js $out

    runHook postInstall
  '';

  meta = with lib; {
    changelog = "https://github.com/zanna-37/hass-swipe-navigation/releases/tag/v${version}";
    description = "Swipe through Home Assistant Dashboard views on mobile";
    homepage = "https://github.com/zanna-37/hass-swipe-navigation";
    license = licenses.mit;
    maintainers = with maintainers; [ jpinz ];
  };
}
