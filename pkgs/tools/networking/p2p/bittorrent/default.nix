{stdenv, fetchurl, python, pygtk, makeWrapper}:

stdenv.mkDerivation {
  name = "bittorrent-5.0.3";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://download.bittorrent.com/dl/BitTorrent-5.0.3.tar.gz;
    md5 = "592363a33c35e9f66759a736dbf7e038";
  };
  buildInputs = [python pygtk];
  inherit python pygtk makeWrapper;

  meta = {
    description = "The original client for the BitTorrent peer-to-peer file sharing protocol";
  };
}
