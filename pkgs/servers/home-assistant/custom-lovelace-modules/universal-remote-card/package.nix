{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "universal-remote-card";
<<<<<<< HEAD
  version = "4.9.3";
=======
  version = "4.9.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "Nerwyn";
    repo = "android-tv-card";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-Xy2qtck1ZrB5y4SPkWC/JrSsoZciBdI7rm2HdakHu3I=";
=======
    hash = "sha256-HvTxuC+qjljFPjRkEjdf+Jy7atpTVtZRU7y05Rcvhps=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  patches = [ ./dont-call-git.patch ];

<<<<<<< HEAD
  npmDepsHash = "sha256-Js9HlQOQUFDU2wIe9JdXqkcKlsAgoE8/d74Zw+9iyN4=";
=======
  npmDepsHash = "sha256-h3E2dJTdR6b+TwkXPdK0+hrMZ+Zj5b27oMDD413cBKM=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp dist/universal-remote-card.min.js $out

    runHook postInstall
  '';

  passthru.entrypoint = "universal-remote-card.min.js";

<<<<<<< HEAD
  meta = {
    description = "Completely customizable universal remote card for Home Assistant. Supports multiple platforms out of the box";
    homepage = "https://github.com/Nerwyn/android-tv-card";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ k900 ];
    platforms = lib.platforms.all;
=======
  meta = with lib; {
    description = "Completely customizable universal remote card for Home Assistant. Supports multiple platforms out of the box";
    homepage = "https://github.com/Nerwyn/android-tv-card";
    license = licenses.asl20;
    maintainers = with maintainers; [ k900 ];
    platforms = platforms.all;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
