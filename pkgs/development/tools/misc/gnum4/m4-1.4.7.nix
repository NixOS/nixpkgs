{stdenv, fetchurl}:
stdenv.mkDerivation {
  name = "gnum4-1.4.7";
  src = fetchurl {
    url = ftp://ftp.nluug.nl/pub/gnu/m4/m4-1.4.7.tar.bz2;
    md5 = "0115a354217e36ca396ad258f6749f51";
  };
}
