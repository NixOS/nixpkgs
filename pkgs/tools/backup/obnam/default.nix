{ stdenv, fetchurl, python, pythonPackages, pycrypto, attr }:

pythonPackages.buildPythonPackage rec {
  name = "obnam-${version}";
  version = "1.15";

  namePrefix = "";

  src = fetchurl rec {
    url = "http://code.liw.fi/debian/pool/main/o/obnam/obnam_${version}.orig.tar.xz";
    sha256 = "1wpvy6qrrp2k0b38a864n0ayh5mr8353rndiqb8ax7z0y3jz484x";
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
