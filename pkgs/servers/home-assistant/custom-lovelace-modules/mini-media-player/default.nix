{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "mini-media-player";
  version = "1.16.6";

  src = fetchFromGitHub {
    owner = "kalkih";
    repo = "mini-media-player";
    rev = "v${version}";
    hash = "sha256-1cC9dyZ9+7dXSL/dmFD0HV7SgsBW2zA7a+eOKVwbzg8=";
  };

  npmDepsHash = "sha256-/7roW1xkZmGuB/8nFaQz0Yeuai6yJ+cH7Uqa/zxfa5w=";

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
