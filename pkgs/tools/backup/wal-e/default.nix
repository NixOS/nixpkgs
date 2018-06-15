{ stdenv, fetchurl, pythonPackages, lzop, postgresql, pv }:

pythonPackages.buildPythonApplication rec {
  name = "wal-e-${version}";
  version = "0.6.10";

  namePrefix = "";

  src = fetchurl {
    url = "https://github.com/wal-e/wal-e/archive/v${version}.tar.gz";
    sha256 = "1hms24xz7wx3b91vv56fhcc3j0cszwqwnmwhka4yl90202hvdir2";
  };

  # needs tox
  doCheck = false;

  propagatedBuildInputs = [
    pythonPackages.boto
    pythonPackages.gevent
    postgresql
    lzop
    pv
  ];

  meta = {
    description = "A Postgres WAL-shipping disaster recovery and replication toolkit";
    homepage = https://github.com/wal-e/wal-e;
    maintainers = [ stdenv.lib.maintainers.rickynils ];
    license = stdenv.lib.licenses.bsd3;
    platforms = stdenv.lib.platforms.linux;
  };
}
