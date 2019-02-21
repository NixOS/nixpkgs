{ stdenv, fetchFromGitHub, python2, makeWrapper }:

let
  pythonEnv = python2.withPackages(ps: with ps; [ cheetah ]);
in stdenv.mkDerivation rec {
  pname = "sickbeard";
  version = "2016-03-21";

  src = fetchFromGitHub {
    owner = "midgetspy";
    repo = "Sick-Beard";
    rev = "171a607e41b7347a74cc815f6ecce7968d9acccf";
    sha256 = "16bn13pvzl8w6nxm36ii724x48z1cnf8y5fl0m5ig1vpqfypk5vq";
  };

  dontBuild = true;
  doCheck = false;

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ pythonEnv ];

  installPhase = ''
    mkdir -p $out/bin
    cp -R {autoProcessTV,cherrypy,data,lib,sickbeard,SickBeard.py} $out/

    makeWrapper $out/SickBeard.py $out/bin/sickbeard
  '';

  meta = with stdenv.lib; {
    description = "PVR & episode guide that downloads and manages all your TV shows";
    license     = licenses.gpl3;
    homepage    = https:/github.com/midgetspy/Sick-Beard;
    maintainers = with stdenv.lib.maintainers; [ ];
  };
}
