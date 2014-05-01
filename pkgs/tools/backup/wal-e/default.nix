{ stdenv, fetchurl, pythonPackages, lzop, postgresql, pv }:

pythonPackages.buildPythonPackage rec {
  name = "wal-e-${version}";
  version = "0.6.9";

  namePrefix = "";

  src = fetchurl {
    url = "https://github.com/wal-e/wal-e/archive/v${version}.tar.gz";
    sha256 = "1yzz9hic8amq7mp0kh04hsmwisk5r374ddja5g8345bl8y3bzbgk";
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
