{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "android-tv-card";
  version = "3.8.1";

  src = fetchFromGitHub {
    owner = "Nerwyn";
    repo = "android-tv-card";
    rev = version;
    hash = "sha256-ARFJJ119zJzjW0d59JFARMcjVAJ2IFDkShIN43d1adI=";
  };

  patches = [ ./dont-call-git.patch ];

  npmDepsHash = "sha256-t/kZTcXs3IpbrEfnmYQlJqhM8F3mO4prbQNnKtFqsDM=";

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
