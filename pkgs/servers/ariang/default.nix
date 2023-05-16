{ lib
, stdenv
, fetchFromGitHub
, buildNpmPackage
, nix-update-script
}:

buildNpmPackage rec {
  pname = "ariang";
<<<<<<< HEAD
  version = "1.3.6";
=======
  version = "1.3.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "mayswind";
    repo = "AriaNg";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-+wwtBEZgU83FNQ5f9oQh5G4RQdCODzoqcV1XfwWKUKg=";
  };

  npmDepsHash = "sha256-KfzD8g6eAWvNjrGaVNt5x4I9o2E273S02o4nkn7BFSs=";
=======
    hash = "sha256-Ki9W66ITdunxU+HQWVf2pG+BROlYFYUJSAySC8wsJRo=";
  };

  npmDepsHash = "sha256-FyIQinOQDJ+k612z/qkl3KW0z85sswRhQCbF6N63z8Y=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
