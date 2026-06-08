{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "universal-remote-card";
  version = "4.11.2";

  src = fetchFromGitHub {
    owner = "Nerwyn";
    repo = "android-tv-card";
    rev = version;
    hash = "sha256-HWQK2k9AlnY+BrmRLoXLJ5CnbgmcdxRTP4BywdtzRjs=";
  };

  npmDepsHash = "sha256-nDK1OAF3KFEMP5NJYarmgC2y+mQ96dMYVTHXgoSozvc=";

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
