{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "lovelace-valetudo-map-card";
  version = "2023.04.0";

  src = fetchFromGitHub {
    owner = "Hypfer";
    repo = "lovelace-valetudo-map-card";
    rev = "v${version}";
    hash = "sha256-owOIbA1tRlnbWJ/p/wAUpeDnz/Wzu+GmUammJ6VFxHc=";
  };

  patches = [ ./remove-git-dependency.patch ];

  npmDepsHash = "sha256-xHHbOt9HW+zJAhHEDy2V5eYyLv4e3OrUbnzqeJasSng=";

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp dist/valetudo-map-card.js $out

    runHook postInstall
  '';

  passthru.entrypoint = "valetudo-map-card.js";

  meta = with lib; {
    description = "Display the map from a valetudo-enabled robot in a home assistant dashboard card";
    homepage = "https://github.com/Hypfer/lovelace-valetudo-map-card";
    license = licenses.mit;
    maintainers = with maintainers; [ k900 ];
    platforms = platforms.all;
  };
}
