{ stdenv, fetchFromGitHub, perl }:

stdenv.mkDerivation rec {
  pname = "mysqltuner";
  version = "1.7.17";

  src = fetchFromGitHub {
    owner  = "major";
    repo   = "MySQLTuner-perl";
    rev    = version;
    sha256 = "0wjdqraa6r6kd6rsgrn177dq6xsnnr1sgnbs9whknjbs4fn3wwl5";
  };

  buildInputs = [ perl ];

  installPhase = ''
    mkdir -p $out/bin
    install -m0755 mysqltuner.pl $out/bin/mysqltuner
  '';

  meta = with stdenv.lib; {
    description = "Make recommendations for increased performance and stability of MariaDB/MySQL";
    homepage = http://mysqltuner.com;
    license = licenses.gpl3;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
