{stdenv, fetchurl, x11, SDL}:

stdenv.mkDerivation {
  name = "atari++-1.46";
#  builder = ./builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/atari++.tgz;
    md5 = "0619ec6b63852233111aa0bd263c8ea2";
  };
#  rom = fetchurl {
#    url = http://surfnet.dl.sourceforge.net/sourceforge/atari800/xf25.zip;
#    md5 = "4dc3b6b4313e9596c4d474785a37b94d";
#  };
  buildInputs = [x11 SDL];
}
