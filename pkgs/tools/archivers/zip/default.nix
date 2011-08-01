{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "zip-2.32";

  src = fetchurl {
    url = ftp://ftp.info-zip.org/pub/infozip/src/zip232.tgz;
    md5 = "8a4da4460386e324debe97f3b7fe4d96";
  };

  buildFlags="-f unix/Makefile generic";

  installFlags="-f unix/Makefile prefix=$out INSTALL=cp";

  meta = {
    homepage = http://www.info-zip.org;
  };
}

