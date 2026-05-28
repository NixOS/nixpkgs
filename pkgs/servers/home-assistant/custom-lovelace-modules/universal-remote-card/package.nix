{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "universal-remote-card";
  version = "4.11.1";

  src = fetchFromGitHub {
    owner = "Nerwyn";
    repo = "android-tv-card";
    rev = version;
    hash = "sha256-qgwY8zoIkKymuG3yxu8oc4wGgbASBMchj+dqvX/xFAA=";
  };

  npmDepsHash = "sha256-m3m0GAmQtSGV4NfAwHqDiAwwFzf+HlEq7OsWOQL8zvQ=";

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
