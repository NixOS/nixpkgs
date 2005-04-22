{stdenv, fetchurl, python, pygtk, makeWrapper}:

stdenv.mkDerivation {
  name = "bittorrent-4.0.1";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://www.bittorrent.com/dl/BitTorrent-4.0.1.tar.gz;
    md5 = "e890d856d43b3d0af14b28714bc5801a";
  };
  buildInputs = [python pygtk];
  inherit python pygtk makeWrapper;
}
