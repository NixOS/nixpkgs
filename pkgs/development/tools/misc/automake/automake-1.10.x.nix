{stdenv, fetchurl, perl, autoconf}:

stdenv.mkDerivation {
  name = "automake-1.10";
  builder = ./builder.sh;
  setupHook = ./setup-hook.sh;
  src = fetchurl {
    url = ftp://ftp.nluug.nl/pub/gnu/automake/automake-1.10.tar.bz2;
    md5 = "0e2e0f757f9e1e89b66033905860fded";
  };
  buildInputs = [perl autoconf];
}
