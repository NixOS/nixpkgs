{stdenv, fetchurl, gettext}:

derivation {
  name = "e2fsprogs-1.34";
  system = stdenv.system;
  builder = ./builder.sh;
  src = fetchurl {
    url = http://heanet.dl.sourceforge.net/sourceforge/e2fsprogs/e2fsprogs-1.34.tar.gz;
    md5 = "9be9375224f0970a55e39ebebf2a0ce5";
  };
  inherit stdenv gettext;
}
