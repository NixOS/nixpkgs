{ stdenv, fetchurl, pkgconfig
, zlib, ghostscript, imagemagick, plotutils, gd
, libjpeg, libwebp
}:

stdenv.mkDerivation rec {
  name = "pstoedit-3.70";

  src = fetchurl {
    url = "mirror://sourceforge/pstoedit/${name}.tar.gz";
    sha256 = "130kz0ghsrggdn70kygrmsy3n533hwd948q69vyvqz44yw9n3f06";
  };

  outputs = [ "out" "dev" ];
  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ zlib ghostscript imagemagick plotutils gd libjpeg libwebp ];

  meta = with stdenv.lib; {
    description = "Translates PostScript and PDF graphics into other vector formats";
    homepage = https://sourceforge.net/projects/pstoedit/;
    license = licenses.gpl2;
    maintainers = [ maintainers.marcweber ];
    platforms = platforms.linux;
  };
}
