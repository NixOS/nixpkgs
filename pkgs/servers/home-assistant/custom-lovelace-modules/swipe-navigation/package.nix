{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "swipe-navigation";
  version = "1.15.8";

  src = fetchFromGitHub {
    owner = "zanna-37";
    repo = "hass-swipe-navigation";
    tag = "v${version}";
    hash = "sha256-jc/dTs1CdrjTSHSnBn2RPESgj3YFjFSg+nPJClKRPj4=";
  };

  npmDepsHash = "sha256-uuNX2xizoS3eowN/edUuT3EvzzLq7GzGw0uIDxAT0pY=";

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
