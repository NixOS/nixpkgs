{stdenv, fetchurl}:
stdenv.mkDerivation {
  name = "gnum4-1.4.4";
  src = fetchurl {
    url = ftp://ftp.nluug.nl/pub/gnu/m4/m4-1.4.4.tar.bz2;
    md5 = "eb93bfbcb12cf00165583302bb31a822";
  };
}
