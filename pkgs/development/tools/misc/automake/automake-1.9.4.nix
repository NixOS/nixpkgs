{stdenv, fetchurl, perl, autoconf}:

stdenv.mkDerivation {
  name = "automake-1.9.4";
  builder = ./builder.sh;
  setupHook = ./setup-hook.sh;
  src = fetchurl {
    url = ftp://ftp.nluug.nl/pub/gnu/automake/automake-1.9.4.tar.gz;
    md5 = "5b46bde56e321a7bab7832168cf0b9b8";
  };
  buildInputs = [perl autoconf];
}
