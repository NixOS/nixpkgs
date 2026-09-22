{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "swipe-navigation";
  version = "1.16.1";

  src = fetchFromGitHub {
    owner = "zanna-37";
    repo = "hass-swipe-navigation";
    tag = "v${version}";
    hash = "sha256-6EMpxiug6YNDjekqyXMIv12Eg4iW42rOR2InNGzGmQU=";
  };

  npmDepsHash = "sha256-cySnkW+UOFSbQtsvx4av7UqVxHH0AEb0LzbFQOIvBME=";

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

  meta = {
    changelog = "https://github.com/zanna-37/hass-swipe-navigation/releases/tag/v${version}";
    description = "Swipe through Home Assistant Dashboard views on mobile";
    homepage = "https://github.com/zanna-37/hass-swipe-navigation";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jpinz ];
  };
}
