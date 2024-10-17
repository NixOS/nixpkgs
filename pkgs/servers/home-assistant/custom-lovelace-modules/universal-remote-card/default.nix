{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "universal-remote-card";
  version = "4.1.0";

  src = fetchFromGitHub {
    owner = "Nerwyn";
    repo = "android-tv-card";
    rev = version;
    hash = "sha256-ze+bsQbPeqfcZ2pWrI4aH3a1+uxus6wC2G9D+uVMrMU=";
  };

  patches = [ ./dont-call-git.patch ];

  npmDepsHash = "sha256-X4PuMvQ/ZmyUafLE7ADBPIKIB8ul5M1P23gOQEikTAg=";

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
