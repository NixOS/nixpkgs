{ stdenv, fetchurl, python3Packages, lzop, postgresql, pv }:

python3Packages.buildPythonApplication rec {
  pname = "wal-e";
  version = "1.1.1";

  namePrefix = "";

  src = fetchurl {
    url = "https://github.com/wal-e/wal-e/archive/v${version}.tar.gz";
    sha256 = "5TTd7NTO73+MCJf3dHIcNojjHdoaKJ1T051iW7Kt9Ow=";
  };

  # needs tox
  doCheck = false;

  propagatedBuildInputs = (with python3Packages; [
    boto
    gevent
    google-cloud-storage
  ]) ++ [
    postgresql
    lzop
    pv
  ];

  meta = {
    description = "A Postgres WAL-shipping disaster recovery and replication toolkit";
    homepage = "https://github.com/wal-e/wal-e";
    maintainers = [];
    license = stdenv.lib.licenses.bsd3;
    platforms = stdenv.lib.platforms.linux;
  };
}
