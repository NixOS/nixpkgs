{stdenv, fetchurl, libsepol}:

stdenv.mkDerivation {
  builder = ./builder.sh;
  name = "libselinux-1.30";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/libselinux-1.30.tgz;
    md5 = "0b7d269c9b7d847059e4b11a710ab404";
  };

  buildInputs = [libsepol];
}
