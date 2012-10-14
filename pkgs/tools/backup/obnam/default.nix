{ stdenv, fetchurl, python, pythonPackages, pycrypto, attr }:

pythonPackages.buildPythonPackage {
  name = "obnam-1.2";
  namePrefix = "";

  src = fetchurl rec {
    url = "http://code.liw.fi/debian/pool/main/o/obnam/obnam_1.2.orig.tar.gz";
    sha256 = "33457452726d5c393d98c565b8e1ab3ac11276cc42bf67c4eee6c4e4ac9976d6";
  };

  buildInputs = [ pythonPackages.sphinx attr ];
  propagatedBuildInputs = [ pycrypto pythonPackages.paramiko pythonPackages.tracing pythonPackages.ttystatus pythonPackages.cliapp pythonPackages.larch ];

  doCheck = false;

  meta = {
    homepage = http://liw.fi/obnam/;
    description = "A backup program supporting deduplication, compression and encryption.";
    maintainers = [ stdenv.lib.maintainers.rickynils ];
    platforms = stdenv.lib.platforms.linux;
  };
}
