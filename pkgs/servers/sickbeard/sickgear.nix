{ lib, stdenv, fetchFromGitHub, python3, makeWrapper }:

let
  pythonEnv = python3.withPackages(ps: with ps; [ cheetah3 ]);
in stdenv.mkDerivation rec {
  pname = "sickgear";
  version = "0.25.35";

  src = fetchFromGitHub {
    owner = "SickGear";
    repo = "SickGear";
    rev = "release_${version}";
    sha256 = "0hc43wfa256nkjm7bvsr6b7xsyilm1ks4x16kvpprqmj1symlkz3";
  };

  dontBuild = true;
  doCheck = false;

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ pythonEnv ];

  postPatch = ''
    substituteInPlace sickgear.py --replace "/usr/bin/env python2" "/usr/bin/env python"
  '';

  installPhase = ''
    mkdir -p $out/bin $out/opt/sickgear
    cp -R {autoProcessTV,gui,lib,sickbeard,sickgear.py} $out/opt/sickgear/

    makeWrapper $out/opt/sickgear/sickgear.py $out/bin/sickgear
  '';

  meta = with lib; {
    description = "The most reliable stable TV fork of the great Sick-Beard to fully automate TV enjoyment with innovation";
    license     = licenses.gpl3;
    homepage    = "https://github.com/SickGear/SickGear";
    maintainers = with lib.maintainers; [ rembo10 ];
  };
}
