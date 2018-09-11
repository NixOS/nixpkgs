{ stdenv, fetchFromGitHub, python2, makeWrapper }:

let
  pythonEnv = python2.withPackages(ps: with ps; [ cheetah ]);
in python2.pkgs.buildPythonApplication rec {
  name = "sickgear-${version}";
  version = "0.17.5";

  src = fetchFromGitHub {
    owner = "SickGear";
    repo = "SickGear";
    rev = "release_${version}";
    sha256 = "1lx060klgxz8gjanfjvya6p6kd8842qbpp1qhhiw49a25r8gyxpk";
  };

  dontBuild = true;
  doCheck = false;

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ pythonEnv ];

  installPhase = ''
    mkdir -p $out
    cp -R * $out/

    mkdir -p $out/bin
    makeWrapper $out/SickBeard.py $out/bin/sickgear
  '';

  meta = with stdenv.lib; {
    description = "The most reliable stable TV fork of the great Sick-Beard to fully automate TV enjoyment with innovation";
    license     = licenses.gpl3;
    homepage    = https:/github.com/SickGear/SickGear;
    maintainers = with stdenv.lib.maintainers; [ ];
  };
}
