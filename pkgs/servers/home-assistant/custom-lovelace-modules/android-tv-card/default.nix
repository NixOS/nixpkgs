{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "android-tv-card";
  version = "3.9.3";

  src = fetchFromGitHub {
    owner = "Nerwyn";
    repo = "android-tv-card";
    rev = version;
    hash = "sha256-le9FdGuYQBi9wlnzSmoumIdYJKh06pFanmJo3V1hkJI=";
  };

  patches = [ ./dont-call-git.patch ];

  npmDepsHash = "sha256-dUJCmiAESlcK09CQweujtH6fN2HxvGUPmQaG7IQMm5U=";

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
