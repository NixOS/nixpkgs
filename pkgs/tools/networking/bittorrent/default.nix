{stdenv, fetchurl, python, pygtk, makeWrapper}:

stdenv.mkDerivation {
  name = "bittorrent-4.2.1";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/BitTorrent-4.2.1.tar.gz;
    md5 = "0deb2e083e95206a9e601ff6ca35b826";
  };
  buildInputs = [python pygtk];
  inherit python pygtk makeWrapper;
}
