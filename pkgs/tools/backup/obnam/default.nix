{ stdenv, fetchurl, python, pythonPackages, pycrypto, attr }:

pythonPackages.buildPythonPackage rec {
  name = "obnam-${version}";
  version = "1.4";

  namePrefix = "";

  src = fetchurl rec {
    url = "http://code.liw.fi/debian/pool/main/o/obnam/obnam_${version}.orig.tar.gz";
    sha256 = "0gipbhh20p9n1x1cdpcil8vg3i20f1saa0xyz2wydb9xl4l2mjff";
  };

  buildInputs = [ pythonPackages.sphinx attr ];
  propagatedBuildInputs = [ pycrypto pythonPackages.paramiko pythonPackages.tracing pythonPackages.ttystatus pythonPackages.cliapp pythonPackages.larch ];

  doCheck = false;

  meta = {
    homepage = http://liw.fi/obnam/;
    description = "Backup program supporting deduplication, compression and encryption";
    maintainers = [ stdenv.lib.maintainers.rickynils ];
    platforms = stdenv.lib.platforms.linux;
  };
}
