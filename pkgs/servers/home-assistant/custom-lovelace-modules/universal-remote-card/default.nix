{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "universal-remote-card";
  version = "4.0.1";

  src = fetchFromGitHub {
    owner = "Nerwyn";
    repo = "android-tv-card";
    rev = version;
    hash = "sha256-AmBbc6nKSHbbkOGsk8z0IsrGfcf5gh6rrXhC8bPFhUM=";
  };

  patches = [ ./dont-call-git.patch ];

  npmDepsHash = "sha256-lFpgO/5JEmnl1wXLuy/OqncxPSx96BTydbprGEN+feM=";

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp dist/universal-remote-card.min.js $out

    runHook postInstall
  '';

  passthru.entrypoint = "universal-remote-card.min.js";

  meta = with lib; {
    description = "Completely customizable universal remote card for Home Assistant. Supports multiple platforms out of the box";
    homepage = "https://github.com/Nerwyn/android-tv-card";
    license = licenses.asl20;
    maintainers = with maintainers; [ k900 ];
    platforms = platforms.all;
  };
}
