{ stdenv, fetchurl, python, pythonPackages, pycrypto, attr }:

pythonPackages.buildPythonPackage rec {
  name = "obnam-${version}";
  version = "1.3";

  namePrefix = "";

  src = fetchurl rec {
    url = "http://code.liw.fi/debian/pool/main/o/obnam/obnam_${version}.orig.tar.gz";
    sha256 = "1hmi58knv7qjw6jr5m28sip5gwzavk87i3s77xk72anaxhvf4g8w";
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
