{ lib, stdenv, fetchFromGitHub, python3, makeWrapper, libarchive }:

let
  pythonEnv = python3.withPackages(ps: with ps; [ cheetah3 lxml ]);
in stdenv.mkDerivation rec {
  pname = "sickgear";
<<<<<<< HEAD
  version = "3.29.3";
=======
  version = "0.25.60";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "SickGear";
    repo = "SickGear";
    rev = "release_${version}";
<<<<<<< HEAD
    hash = "sha256-aPpzWGVQS7waPJXHSdL/6cBhARgpE7/uIdvSadvsB0A=";
=======
    sha256 = "sha256-5I6hJgUN2BdHc80RrcmWWxdq0iz6rcO4aX16CDtwu/g=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  patches = [
    ./patches/override-python-version-check.patch
  ];

  dontBuild = true;
  doCheck = false;

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ pythonEnv libarchive ];

<<<<<<< HEAD
  installPhase = ''
    mkdir -p $out/bin $out/opt/sickgear
    cp -R {autoProcessTV,gui,lib,sickgear,sickgear.py} $out/opt/sickgear/

    makeWrapper $out/opt/sickgear/sickgear.py $out/bin/sickgear \
      --suffix PATH : ${lib.makeBinPath [ libarchive ]}
=======
  postPatch = ''
    substituteInPlace sickgear.py --replace "/usr/bin/env python2" "/usr/bin/env python"
  '';

  installPhase = ''
    mkdir -p $out/bin $out/opt/sickgear
    cp -R {autoProcessTV,gui,lib,sickbeard,sickgear.py} $out/opt/sickgear/

    makeWrapper $out/opt/sickgear/sickgear.py $out/bin/sickgear
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  meta = with lib; {
    description = "The most reliable stable TV fork of the great Sick-Beard to fully automate TV enjoyment with innovation";
    license     = licenses.gpl3;
    homepage    = "https://github.com/SickGear/SickGear";
    maintainers = with lib.maintainers; [ rembo10 ];
  };
}
