{ stdenv, fetchFromGitHub, perl }:

stdenv.mkDerivation rec {
  name = "mysqltuner-${version}";
  version = "1.6.18";

  src = fetchFromGitHub {
    owner  = "major";
    repo   = "MySQLTuner-perl";
    rev    = version;
    sha256 = "14dblrjqciyx6k7yczfzbaflc7hdxnj0kyy6q0lqfz8imszdkpi2";
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
