{ lib
, stdenv
, fetchFromGitHub
, buildNpmPackage
, nix-update-script
}:

buildNpmPackage rec {
  pname = "ariang";
  version = "1.3.5";

  src = fetchFromGitHub {
    owner = "mayswind";
    repo = "AriaNg";
    rev = version;
    hash = "sha256-Ki9W66ITdunxU+HQWVf2pG+BROlYFYUJSAySC8wsJRo=";
  };

  npmDepsHash = "sha256-FyIQinOQDJ+k612z/qkl3KW0z85sswRhQCbF6N63z8Y=";

  makeCacheWritable = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share
    cp -r dist $out/share/ariang

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {};

  meta = with lib; {
    description = "a modern web frontend making aria2 easier to use";
    homepage = "http://ariang.mayswind.net/";
    license = licenses.mit;
    maintainers = with maintainers; [ stunkymonkey ];
    platforms = platforms.unix;
  };
}
