{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "gnumake-3.81";
  src = fetchurl {
    url = http://ftp.gnu.org/pub/gnu/make/make-3.81.tar.bz2;
    md5 = "354853e0b2da90c527e35aabb8d6f1e6";
  };
  patches = [./log.diff];
}
