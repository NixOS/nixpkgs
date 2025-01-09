{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "universal-remote-card";
  version = "4.3.4";

  src = fetchFromGitHub {
    owner = "Nerwyn";
    repo = "android-tv-card";
    rev = version;
    hash = "sha256-PTVO84HwxmLdwWNsSA8FfcVqPREyVVSuDbXbcZm63+E=";
  };

  patches = [ ./dont-call-git.patch ];

  npmDepsHash = "sha256-nh8JG+cH3KgSwlTvu5wvrBgPIOXN0LXIKh/RmYw2OO0=";

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
