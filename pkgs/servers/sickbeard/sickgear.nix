{ lib, stdenv, fetchFromGitHub, python3, makeWrapper, libarchive }:

let
  pythonEnv = python3.withPackages(ps: with ps; [ cheetah3 lxml ]);
in stdenv.mkDerivation rec {
  pname = "sickgear";
  version = "3.31.1";

  src = fetchFromGitHub {
    owner = "SickGear";
    repo = "SickGear";
    rev = "release_${version}";
    hash = "sha256-qcivNJ3CrvToT8CBq5Z/xssP/srTerXJfRGXcvNh2Ag=";
  };

  patches = [
    ./patches/override-python-version-check.patch
  ];

  dontBuild = true;
  doCheck = false;

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ pythonEnv libarchive ];

  installPhase = ''
    mkdir -p $out/bin $out/opt/sickgear
    cp -R {autoProcessTV,gui,lib,sickgear,sickgear.py} $out/opt/sickgear/

    makeWrapper $out/opt/sickgear/sickgear.py $out/bin/sickgear \
      --suffix PATH : ${lib.makeBinPath [ libarchive ]}
  '';

  meta = with lib; {
    description = "Most reliable stable TV fork of the great Sick-Beard to fully automate TV enjoyment with innovation";
    mainProgram = "sickgear";
    license     = licenses.gpl3;
    homepage    = "https://github.com/SickGear/SickGear";
    maintainers = with lib.maintainers; [ rembo10 ];
  };
}
