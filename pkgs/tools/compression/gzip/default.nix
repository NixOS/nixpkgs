{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "gzip-1.3.9";
  src = fetchurl {
    url = ftp://ftp.nluug.nl/pub/gnu/gzip/gzip-1.3.9.tar.gz;
    md5 = "7cf923b24b718c418e85a283b2260e14";
  };
  postInstall = "ln -sf gzip $out/bin/gunzip; ln -sf gzip $out/bin/zcat";
}
