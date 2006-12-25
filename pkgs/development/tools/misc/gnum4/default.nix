{stdenv, fetchurl}:
stdenv.mkDerivation {
  name = "gnum4-1.4.8";
  src = fetchurl {
    url = ftp://ftp.nluug.nl/pub/gnu/m4/m4-1.4.8.tar.bz2;
    md5 = "6bbf917e5d8fab20b38d43868c3944d3";
  };
}
