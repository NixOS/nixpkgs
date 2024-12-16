{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "universal-remote-card";
  version = "4.2.1";

  src = fetchFromGitHub {
    owner = "Nerwyn";
    repo = "android-tv-card";
    rev = version;
    hash = "sha256-Gw8lPAXKZ/PqeH7DeKMU/ZIM+s9xwzDGWzR/G82fOfI=";
  };

  patches = [ ./dont-call-git.patch ];

  npmDepsHash = "sha256-QN7X44yRZDoS/KAQU+FxkExwvED47E/5rvKNqUjYwKA=";

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
