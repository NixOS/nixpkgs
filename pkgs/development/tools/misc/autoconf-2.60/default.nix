{stdenv, fetchurl, m4, perl}:

stdenv.mkDerivation {
  name = "autoconf-2.60";
  src = fetchurl {
    url = ftp://ftp.nluug.nl/pub/gnu/autoconf/autoconf-2.60.tar.bz2;
    md5 = "019609c29d0cbd9110c38480304aafc8";
  };
  buildInputs = [m4 perl];
}
