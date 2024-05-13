{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "android-tv-card";
  version = "3.7.0";

  src = fetchFromGitHub {
    owner = "Nerwyn";
    repo = "android-tv-card";
    rev = version;
    hash = "sha256-6SwSoFeGS3kzk4jz+vSVb8ENMcSFxaunyTzuPe1kHBI=";
  };

  patches = [ ./dont-call-git.patch ];

  npmDepsHash = "sha256-QO3IAd7RC8VBa2YjQVn4HUm64mQL86OuAhjJO0Oo94M=";

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
