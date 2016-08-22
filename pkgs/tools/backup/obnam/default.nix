{ stdenv, fetchurl, pythonPackages, attr }:

pythonPackages.buildPythonApplication rec {
  name = "obnam-${version}";
  version = "1.19.1";

  src = fetchurl rec {
    url = "http://code.liw.fi/debian/pool/main/o/obnam/obnam_${version}.orig.tar.xz";
    sha256 = "096abbvz2c9vm8r7zm82yqrd7zj04pb1xzlv6z0dspkngd0cfdqc";
  };

  buildInputs = [ pythonPackages.sphinx attr ];
  propagatedBuildInputs = with pythonPackages; [ pycrypto paramiko tracing ttystatus cliapp larch pyyaml fuse ];

  doCheck = false;

  meta = {
    homepage = http://liw.fi/obnam/;
    description = "Backup program supporting deduplication, compression and encryption";
    maintainers = [ stdenv.lib.maintainers.rickynils ];
    platforms = stdenv.lib.platforms.linux;
  };
}
