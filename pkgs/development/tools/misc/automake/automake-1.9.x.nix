{stdenv, fetchurl, perl, autoconf}:

stdenv.mkDerivation {
  name = "automake-1.9.6";
  builder = ./builder.sh;
  setupHook = ./setup-hook.sh;
  src = fetchurl {
    url = ftp://ftp.gnu.org/gnu/automake/automake-1.9.6.tar.gz;
    md5 = "c60f77a42f103606981d456f1615f5b4";
  };
  buildInputs = [perl autoconf];
}
