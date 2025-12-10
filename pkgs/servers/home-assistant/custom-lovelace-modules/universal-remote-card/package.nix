{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "universal-remote-card";
  version = "4.9.2";

  src = fetchFromGitHub {
    owner = "Nerwyn";
    repo = "android-tv-card";
    rev = version;
    hash = "sha256-ifFs+C42i8Iq1CLJIgJ1MRyNzVczDSAur2NJNWMjQSc=";
  };

  patches = [ ./dont-call-git.patch ];

  npmDepsHash = "sha256-4RpBYUBlKqogaiibbiUGK1pS3ZN5h9teKjqFJPMJiIY=";

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
