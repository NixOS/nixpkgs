{stdenv, fetchurl}: derivation {
  name = "pkgconfig-0.15.0";
  system = stdenv.system;
  builder = ./builder.sh;
  src = fetchurl {
    url = http://www.freedesktop.org/software/pkgconfig/releases/pkgconfig-0.15.0.tar.gz;
    md5 = "a7e4f60a6657dbc434334deb594cc242";
  };
  stdenv = stdenv;
}
