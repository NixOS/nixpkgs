{ stdenv, fetchurl, libuuid }:

stdenv.mkDerivation rec {
  name = "jfsutils-1.1.12";

  src = fetchurl {
    url = "http://jfs.sourceforge.net/project/pub/${name}.tar.gz";
    sha256 = "04vqdlg90j0mk5jkxpfg9fp6ss4gs1g5pappgns6183q3i6j02hd";
  };

  buildInputs = [ libuuid ];

  meta = {
    description = "IBM JFS utilities";
  };
}
