{ stdenv, fetchurl, xorg }:

stdenv.mkDerivation {
  pname = "spacenavd";
  version = "0.7.1";
  src = fetchurl {
    url = "https://github.com/FreeSpacenav/spacenavd/releases/download/v0.7.1/spacenavd-0.7.1.tar.gz";
    sha256 = "0awxa90rqmpvwa04fy1wz0hq0cq4c579h5hgmjdwgavxhjdy2rlj";
  };
  buildInputs = [ xorg.libX11 ];
}


