<<<<<<< HEAD
{ lib
, stdenv
, fetchurl
, unzip
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bootstrap";
  version = "5.3.1";

  src = fetchurl {
    url = "https://github.com/twbs/bootstrap/releases/download/v${finalAttrs.version}/bootstrap-${finalAttrs.version}-dist.zip";
    hash = "sha256-SfxkgJujf07f2vq0ViDhjGgRDCeg32L0RKDHHTWBp6Q=";
=======
{ lib, stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  pname = "bootstrap";
  version = "5.2.3";

  src = fetchurl {
    url = "https://github.com/twbs/bootstrap/releases/download/v${version}/${pname}-${version}-dist.zip";
    sha256 = "sha256-j6IBaj3uHiBL0WI+BQ3PR36dKME7uYofWPV+D9QM3Tg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ unzip ];

  dontBuild = true;
  installPhase = ''
<<<<<<< HEAD
    runHook preInstall

    mkdir $out
    cp -r * $out/

    runHook postInstall
=======
    mkdir $out
    cp -r * $out/
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  meta = {
    description = "Front-end framework for faster and easier web development";
    homepage = "https://getbootstrap.com/";
    license = lib.licenses.mit;
  };
<<<<<<< HEAD
})
=======

}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
