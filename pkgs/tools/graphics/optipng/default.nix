{ stdenv, fetchurl }:

# This package comes with its own copy of zlib, libpng and pngxtern

stdenv.mkDerivation rec {
  name = "optipng-0.6.5";

  src = fetchurl {
    url = "mirror://sourceforge/optipng/${name}.tar.gz";
    sha256 = "0i2vpakj60bb0zgy4bynly2mwxiv5fq48yjqjzmrbnqwjh1y5619";
  };

  meta = {
    homepage = http://optipng.sourceforge.net/;
    description = "A PNG optimizer";
    license = "bsd";
  };
}
