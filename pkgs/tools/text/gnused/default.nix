{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "gnused-4.1.5";
  src = fetchurl {
    url = ftp://ftp.nluug.nl/pub/gnu/sed/sed-4.1.5.tar.gz;
    md5 = "7a1cbbbb3341287308e140bd4834c3ba";
  };
}
