{ stdenv, fetchFromGitHub, perl }:

stdenv.mkDerivation rec {
  name = "mysqltuner-${version}";
  version = "1.7.13";

  src = fetchFromGitHub {
    owner  = "major";
    repo   = "MySQLTuner-perl";
    rev    = version;
    sha256 = "0zxm2hjvgznbbmsqb8bpcgzc0yq1ikxz1gckirp95ibxid3jdham";
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
