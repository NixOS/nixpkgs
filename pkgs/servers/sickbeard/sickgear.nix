{ lib, stdenv, fetchFromGitHub, python3, makeWrapper }:

let
  pythonEnv = python3.withPackages(ps: with ps; [ cheetah3 ]);
in stdenv.mkDerivation rec {
  pname = "sickgear";
  version = "0.25.31";

  src = fetchFromGitHub {
    owner = "SickGear";
    repo = "SickGear";
    rev = "release_${version}";
    sha256 = "11l537c7d6mrbvn24bfkzydb96mwzhr8z5rl6imiphjzr0f8qyyp";
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
