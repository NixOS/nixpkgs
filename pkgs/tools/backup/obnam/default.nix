{ stdenv, fetchurl, pythonPackages, attr }:

pythonPackages.buildPythonApplication rec {
  name = "obnam-${version}";
  version = "1.22";

  src = fetchurl rec {
    url = "http://code.liw.fi/debian/pool/main/o/obnam/obnam_${version}.orig.tar.xz";
    sha256 = "0z3absbcpdk8zmmi6n3vwmwyv0pnzy7lp1rcsymb292p04alcn3x";
  };

  buildInputs = [ pythonPackages.sphinx attr ];
  propagatedBuildInputs = with pythonPackages; [ pycrypto paramiko tracing ttystatus cliapp larch pyyaml fuse ];

  doCheck = false;

  meta = {
    homepage = http://obnam.org;
    description = "Backup program supporting deduplication, compression and encryption";
    maintainers = [ stdenv.lib.maintainers.rickynils ];
    platforms = stdenv.lib.platforms.linux;
  };
}
