{stdenv, fetchurl, perl, autoconf}:

stdenv.mkDerivation {
  name = "automake-1.9.4";
  builder = ./builder.sh;
  setupHook = ./setup-hook.sh;
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/automake-1.9.4.tar.gz;
    md5 = "5b46bde56e321a7bab7832168cf0b9b8";
  };
  buildInputs = [perl autoconf];
}
