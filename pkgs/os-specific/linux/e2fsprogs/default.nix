{stdenv, fetchurl, gettext}:

stdenv.mkDerivation {
  name = "e2fsprogs-1.34";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://heanet.dl.sourceforge.net/sourceforge/e2fsprogs/e2fsprogs-1.34.tar.gz;
    md5 = "9be9375224f0970a55e39ebebf2a0ce5";
  };
  inherit gettext;
}
