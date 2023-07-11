{ lib
, stdenv
, fetchFromGitHub
, buildNpmPackage
, nix-update-script
}:

buildNpmPackage rec {
  pname = "ariang";
  version = "1.3.6";

  src = fetchFromGitHub {
    owner = "mayswind";
    repo = "AriaNg";
    rev = version;
    hash = "sha256-+wwtBEZgU83FNQ5f9oQh5G4RQdCODzoqcV1XfwWKUKg=";
  };

  npmDepsHash = "sha256-KfzD8g6eAWvNjrGaVNt5x4I9o2E273S02o4nkn7BFSs=";

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
