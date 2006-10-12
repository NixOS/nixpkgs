{stdenv, fetchurl, python, pygtk, makeWrapper}:

stdenv.mkDerivation {
  name = "bittorrent-4.4.0";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/BitTorrent-4.4.0.tar.gz;
    md5 = "74d4b48202c28f0b27e989b6d5f5b214";
  };
  buildInputs = [python pygtk];
  inherit python pygtk makeWrapper;

  meta = {
    description = "The original client for the BitTorrent peer-to-peer file sharing protocol";
  };
}
