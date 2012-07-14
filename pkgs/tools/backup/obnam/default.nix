{ stdenv, fetchurl, python, pythonPackages, pycrypto, attr }:

pythonPackages.buildPythonPackage {
  name = "obnam-1.1";
  namePrefix = "";

  src = fetchurl rec {
    url = "http://code.liw.fi/debian/pool/main/o/obnam/obnam_1.1.orig.tar.gz";
    sha256 = "763693e5ea4e8d6a63b1a16c2aacd5fe0dc97abc687c8f0dde5840f77d549349";
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
