{ stdenv, fetchFromGitHub, python2, makeWrapper }:

let
  pythonEnv = python2.withPackages(ps: with ps; [ cheetah ]);
in stdenv.mkDerivation rec {
  pname = "sickgear";
  version = "0.21.5";

  src = fetchFromGitHub {
    owner = "SickGear";
    repo = "SickGear";
    rev = "release_${version}";
    sha256 = "1wzfdf6300vabflsdbkizjg322in1rgksp7dk8gii38czja9y893";
  };

  dontBuild = true;
  doCheck = false;

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ pythonEnv ];

  installPhase = ''
    mkdir -p $out/bin
    cp -R {autoProcessTV,gui,lib,sickbeard,sickgear.py,SickBeard.py} $out/

    makeWrapper $out/SickBeard.py $out/bin/sickgear
  '';

  meta = with stdenv.lib; {
    description = "The most reliable stable TV fork of the great Sick-Beard to fully automate TV enjoyment with innovation";
    license     = licenses.gpl3;
    homepage    = "https://github.com/SickGear/SickGear";
    maintainers = with stdenv.lib.maintainers; [ rembo10 ];
  };
}
