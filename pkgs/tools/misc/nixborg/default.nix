{ stdenv, python3, fetchFromGitHub }:

let
  server = python3.pkgs.buildPythonApplication rec {
    name = "nixborg-${version}";
    src = fetchFromGitHub {
      owner = "mayflower";
      repo = "nixborg";
      rev = "c328967e6df6f8467aab8d899fdb8d2e8c6f8b9c";
      sha256 = "0n87fc1x6rll2x18ij04lw2p1fsah2lw94nygl5i00gslhjgfbc7";
    };
    version = "2017-11-04";

    propagatedBuildInputs = with python3.pkgs; [
      PyGithub flask flask_migrate flask_sqlalchemy celery redis requests
    ];

    doCheck = false;

    meta = with stdenv.lib; {
      description = "Github bot for reviewing/testing pull requests with the help of Hydra";
      maintainers = with maintainers; [ domenkozar fpletz globin ];
      license = licenses.asl20;
      homepage = https://github.com/mayflower/nixborg;
    };
  };
  receiver = stdenv.mkDerivation rec {
    name = "nixborg-receiver-${version}";
    inherit (server) src version meta;

    buildInputs = [ python3 ];
    dontBuild = true;

    installPhase = ''
      install -vD nixborg/receiver.py $out/bin/nixborg-receiver
    '';
  };
in { inherit server receiver; }
