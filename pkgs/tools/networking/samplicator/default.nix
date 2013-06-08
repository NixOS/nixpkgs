{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "samplicator-${version}";
  version = "1.3.7-beta6";

  src = fetchurl {
    url = "http://samplicator.googlecode.com/files/${name}.tar.gz";
    sha1 = "2091af1898d6508ad9fd338a07e352e2387522d4";
  };

  meta = {
    description = "Send copies of (UDP) datagrams to multiple receivers";
    homepage = "http://code.google.com/p/samplicator/";
    license = stdenv.lib.licenses.gpl2Plus;
  };
}
