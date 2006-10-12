{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "strace-4.5.14";

  builder = ./builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/strace-4.5.14.tar.bz2;
    md5 = "09bcd5d00ece28f8154dec11cadfce3c";
  };
}
