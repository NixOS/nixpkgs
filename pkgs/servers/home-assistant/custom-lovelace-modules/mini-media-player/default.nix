{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "mini-media-player";
  version = "1.16.5";

  src = fetchFromGitHub {
    owner = "kalkih";
    repo = "mini-media-player";
    rev = "v${version}";
    hash = "sha256-ydkY7Qx2GMh4CpvvBAQubJ7PlxSscDZRJayn82bOczM=";
  };

  npmDepsHash = "sha256-v9NvZOrQPMOoG3LKACnu79jKgZtcnGiopWad+dFbplw=";

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -v ./dist/mini-media-player-bundle.js $out/

    runHook postInstall
  '';

  passthru.entrypoint = "mini-media-player-bundle.js";

  meta = with lib; {
    changelog = "https://github.com/kalkih/mini-media-player/releases/tag/v${version}";
    description = "Minimalistic media card for Home Assistant Lovelace UI";
    homepage = "https://github.com/kalkih/mini-media-player";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
