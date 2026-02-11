{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "universal-remote-card";
  version = "4.9.8";

  src = fetchFromGitHub {
    owner = "Nerwyn";
    repo = "android-tv-card";
    rev = version;
    hash = "sha256-STFHbPY4LVHe/YRLS9TY+dGOnxvtboCHpo/7APsno/Y=";
  };

  npmDepsHash = "sha256-urxholQl5UWMqZwlArHaqvAE0FHTrNxZlS9wmU4Zpk8=";

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp dist/universal-remote-card.min.js $out

    runHook postInstall
  '';

  passthru.entrypoint = "universal-remote-card.min.js";

  meta = {
    description = "Completely customizable universal remote card for Home Assistant. Supports multiple platforms out of the box";
    homepage = "https://github.com/Nerwyn/android-tv-card";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ k900 ];
    platforms = lib.platforms.all;
  };
}
