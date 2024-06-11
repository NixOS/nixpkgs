{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "android-tv-card";
  version = "3.7.4";

  src = fetchFromGitHub {
    owner = "Nerwyn";
    repo = "android-tv-card";
    rev = version;
    hash = "sha256-5GdN6zCE24kGLM4ka8vHdpIEWTQAzve/1l3+5OV95i0=";
  };

  patches = [ ./dont-call-git.patch ];

  npmDepsHash = "sha256-fVnqGe/ao0Ilk/mWbHGscYQlIIk3K0mpm1wS4F8Lio4=";

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp dist/android-tv-card.min.js $out

    runHook postInstall
  '';

  passthru.entrypoint = "android-tv-card.min.js";

  meta = with lib; {
    description = "Universal Customizable TV Remote Card, with HA actions, super configurable touchpad, slider, haptics, and keyboard";
    homepage = "https://github.com/Nerwyn/android-tv-card";
    license = licenses.asl20;
    maintainers = with maintainers; [ k900 ];
    platforms = platforms.all;
  };
}
