{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "gnused-4.0.7";
  src = fetchurl {
    url = ftp://ftp.nluug.nl/pub/gnu/sed/sed-4.0.7.tar.gz;
    md5 = "005738e7f97bd77d95b6907156c8202a";
  };
}
