{ stdenv, fetchurl, pythonPackages, attr }:

pythonPackages.buildPythonApplication rec {
  name = "obnam-${version}";
  version = "1.20.2";

  src = fetchurl rec {
    url = "http://code.liw.fi/debian/pool/main/o/obnam/obnam_${version}.orig.tar.xz";
    sha256 = "0r8gngjir9pinj5vp2aq326g74wnhv075n8y9i0hgc5cfvckjjmq";
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
