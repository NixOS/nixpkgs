{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "pkgconfig-0.15.0";
  builder = ./builder.sh;
  setupHook = ./setup-hook.sh;
  src = fetchurl {
    url = http://www.freedesktop.org/software/pkgconfig/releases/pkgconfig-0.15.0.tar.gz;
    md5 = "a7e4f60a6657dbc434334deb594cc242";
  };
}
