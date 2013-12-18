{ stdenv, fetchurl, python, pythonPackages, pycrypto, attr }:

pythonPackages.buildPythonPackage rec {
  name = "obnam-${version}";
  version = "1.6";

  namePrefix = "";

  src = fetchurl rec {
    url = "http://code.liw.fi/debian/pool/main/o/obnam/obnam_${version}.orig.tar.gz";
    sha256 = "1vg0kppbyngvm7wi2pbg3himixy9v3h8z66lcps6pclw43s1kgpm";
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
