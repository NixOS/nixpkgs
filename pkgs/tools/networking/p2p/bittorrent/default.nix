{stdenv, fetchurl, python, pygtk, makeWrapper}:

stdenv.mkDerivation {
  name = "bittorrent-4.9.8";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://download.bittorrent.com/dl/BitTorrent-4.9.8.tar.gz;
    md5 = "30d14135a8c6869976cd807db019dfd9";
  };
  buildInputs = [python pygtk];
  inherit python pygtk makeWrapper;
}
