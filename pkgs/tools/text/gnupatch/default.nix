{stdenv, fetchurl}: stdenv.mkDerivation {
  name = "gnupatch-2.5.4";
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.nluug.nl/pub/gnu/patch/patch-2.5.4.tar.gz;
    md5 = "ee5ae84d115f051d87fcaaef3b4ae782";
  };
}
