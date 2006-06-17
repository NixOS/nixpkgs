{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "coreutils-5.96";
  src = fetchurl {
    url = ftp://ftp.nluug.nl/pub/gnu/coreutils/coreutils-5.96.tar.bz2;
    md5 = "bf55d069d82128fd754a090ce8b5acff";
  };
}
