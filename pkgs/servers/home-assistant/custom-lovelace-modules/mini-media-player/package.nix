{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "mini-media-player";
  version = "1.16.11";

  src = fetchFromGitHub {
    owner = "kalkih";
    repo = "mini-media-player";
    rev = "v${version}";
    hash = "sha256-jbT+skF/WQmfPob6TZ7ff9mgnWvC9siE+WgFONXqGbw=";
  };

  npmDepsHash = "sha256-crF/KesvY5GvH14n9KrND5O7sJxsSV2Nbcod2stesvg=";

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -v ./dist/mini-media-player-bundle.js $out/

    runHook postInstall
  '';

  passthru.entrypoint = "mini-media-player-bundle.js";

  meta = {
    changelog = "https://github.com/kalkih/mini-media-player/releases/tag/v${version}";
    description = "Minimalistic media card for Home Assistant Lovelace UI";
    homepage = "https://github.com/kalkih/mini-media-player";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
