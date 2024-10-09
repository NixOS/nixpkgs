{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "universal-remote-card";
  version = "4.0.6";

  src = fetchFromGitHub {
    owner = "Nerwyn";
    repo = "android-tv-card";
    rev = version;
    hash = "sha256-daxuvbjbnB1OZbvVGrA/jRe65x3MCXGFQ3o4L17Bgjk=";
  };

  patches = [ ./dont-call-git.patch ];

  npmDepsHash = "sha256-AQYsXaZ4TyL8QjxOfub24NBxp0U6WMe+Czq+ooXwkIw=";

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
