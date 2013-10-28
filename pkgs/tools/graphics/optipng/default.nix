{ stdenv, fetchurl }:

# This package comes with its own copy of zlib, libpng and pngxtern

stdenv.mkDerivation rec {
  name = "optipng-0.7.4";

  src = fetchurl {
    url = "mirror://sourceforge/optipng/${name}.tar.gz";
    sha256 = "1zrphbz17rhhfl1l95q5s979rrhifbwczl2xj1fdrnq5jid5s2sj";
  };

  meta = {
    homepage = http://optipng.sourceforge.net/;
    description = "A PNG optimizer";
    license = "bsd";
  };
}
