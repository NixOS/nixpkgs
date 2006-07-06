{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "bzip2-1.0.3";
  builder =
    if stdenv.system == "powerpc-darwin" || stdenv.system == "i686-darwin" then ./builder-darwin.sh
    else if stdenv.system == "i686-freebsd" then ./builder-freebsd.sh
    else if stdenv.system == "i686-cygwin" then ./builder-cygwin.sh
    else ./builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/bzip2-1.0.3.tar.gz;
    md5 = "8a716bebecb6e647d2e8a29ea5d8447f";
  };
}
