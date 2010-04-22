{ stdenv, fetchurl }:

# This package comes with its own copy of zlib, libpng and pngxtern

stdenv.mkDerivation rec {
  name = "optipng-0.6.4";

  src = fetchurl {
    url = "mirror://sourceforge/optipng/${name}.tar.gz";
    sha256 = "0ivnm07zlww20i7dba0zk5dyg8f3hlj03j7vazq520r43lmqj01h";
  };

  meta = {
    homepage = http://optipng.sourceforge.net/;
    description = "A PNG optimizer";
    license = "bsd";
  };
}
