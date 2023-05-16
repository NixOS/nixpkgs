<<<<<<< HEAD
{ lib
, fetchFromGitHub
, python3
, stdenv
, strip-nondeterminism
, zip
}:

let
=======
{ lib, stdenv, fetchFromGitHub, python3, zip }: let
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  version = "1.1.0";
  sha256 = "sha256-563xOz63vto19yuaHtReV1dSw6BgNf+CLtS3lrPnaoc=";

  pname = "pridefetch";
  src = fetchFromGitHub {
    owner = "SpyHoodle";
    repo = pname;
    rev = "v" + version;
    inherit sha256;
  };
<<<<<<< HEAD
in

stdenv.mkDerivation {
  inherit pname version src;

  nativeBuildInputs = [
    strip-nondeterminism
    zip
  ];

=======
in stdenv.mkDerivation {
  inherit pname version src;
  nativeBuildInputs = [
    zip
  ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  buildInputs = [
    (python3.withPackages (pythonPackages: with pythonPackages; [
      distro
    ]))
  ];
<<<<<<< HEAD

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  buildPhase = ''
    runHook preBuild
    pushd src
    zip -r ../pridefetch.zip ./*
<<<<<<< HEAD
    strip-nondeterminism ../pridefetch.zip
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    popd
    echo '#!/usr/bin/env python' | cat - pridefetch.zip > pridefetch
    rm pridefetch.zip
    runHook postBuild
  '';
<<<<<<< HEAD

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    mv pridefetch $out/bin/pridefetch
    chmod +x $out/bin/pridefetch
    runHook postInstall
  '';
<<<<<<< HEAD

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "Print out system statistics with pride flags";
    longDescription = ''
      Pridefetch prints your system statistics (similarly to neofetch, screenfetch or pfetch) along with a pride flag.
      The flag which is printed is configurable, as well as the width of the output.
    '';
    homepage = "https://github.com/SpyHoodle/pridefetch";
    license = licenses.mit;
    maintainers = [
      maintainers.minion3665
    ];
    platforms = platforms.all;
  };
}
