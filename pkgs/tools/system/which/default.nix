{stdenv, fetchurl}: derivation {
  name = "which-2.16";
  system = stdenv.system;
  builder = ./builder.sh;
  src = fetchurl {
    url = http://ftp.gnu.org/gnu/which/which-2.16.tar.gz;
    md5 = "830b83af48347a9a3520f561e47cbc9b";
  };
  stdenv = stdenv;
}



