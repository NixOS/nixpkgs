{stdenv, fetchurl, pcre}:

stdenv.mkDerivation {
  name = "gnugrep-2.5.1";
  src = fetchurl {
    url = ftp://ftp.nluug.nl/pub/gnu/grep/grep-2.5.1.tar.bz2;
    md5 = "ddd99e2d5d4f4611357e31e97f080cf2";
  };
  buildInputs = [pcre];
}
