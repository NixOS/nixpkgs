{ lib, stdenv, fetchFromGitHub, perl }:

stdenv.mkDerivation rec {
  pname = "mysqltuner";
  version = "1.7.21";

  src = fetchFromGitHub {
    owner  = "major";
    repo   = "MySQLTuner-perl";
    rev    = version;
    sha256 = "sha256-Yv1XjD8sZcmGr2SVD6TEElUH7vspJ61WwQwfXLOrao0=";
  };

  buildInputs = [ perl ];

  installPhase = ''
    mkdir -p $out/bin
    install -m0755 mysqltuner.pl $out/bin/mysqltuner
  '';

  meta = with lib; {
    description = "Make recommendations for increased performance and stability of MariaDB/MySQL";
    homepage = "http://mysqltuner.com";
    license = licenses.gpl3;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
