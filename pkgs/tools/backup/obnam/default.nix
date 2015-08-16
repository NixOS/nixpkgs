{ stdenv, fetchurl, python, pythonPackages, pycrypto, attr }:

pythonPackages.buildPythonPackage rec {
  name = "obnam-${version}";
  version = "1.14";

  namePrefix = "";

  src = fetchurl rec {
    url = "http://code.liw.fi/debian/pool/main/o/obnam/obnam_${version}.orig.tar.xz";
    sha256 = "16875g14b7mxfd46159b92qa3gxq59w5gzf8x2n7icqa05s3483q";
  };

  buildInputs = [ pythonPackages.sphinx attr ];
  propagatedBuildInputs = [ pycrypto pythonPackages.paramiko pythonPackages.tracing pythonPackages.ttystatus pythonPackages.cliapp pythonPackages.larch pythonPackages.pyyaml pythonPackages.fuse ];

  doCheck = false;

  meta = {
    homepage = http://liw.fi/obnam/;
    description = "Backup program supporting deduplication, compression and encryption";
    maintainers = [ stdenv.lib.maintainers.rickynils ];
    platforms = stdenv.lib.platforms.linux;
  };
}
