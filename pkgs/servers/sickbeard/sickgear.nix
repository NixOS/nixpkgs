{ stdenv, fetchFromGitHub, python2, makeWrapper }:

let
  pythonEnv = python2.withPackages(ps: with ps; [ cheetah ]);
in stdenv.mkDerivation rec {
  pname = "sickgear";
  version = "0.21.22";

  src = fetchFromGitHub {
    owner = "SickGear";
    repo = "SickGear";
    rev = "release_${version}";
    sha256 = "16jwvg9mcv0yr94ldncfs6bczyv4n3q9v7g7v0ssrkrnkxh722zx";
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
