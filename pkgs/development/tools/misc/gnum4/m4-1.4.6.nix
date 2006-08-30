{stdenv, fetchurl}:
stdenv.mkDerivation {
  name = "gnum4-1.4.6";
  src = fetchurl {
    url = ftp://ftp.nluug.nl/pub/gnu/m4/m4-1.4.6.tar.bz2;
    md5 = "f5babaaa1e337f0aee3bdee55c758d79";
  };
}
