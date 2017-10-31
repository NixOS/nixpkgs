{ stdenv, fetchurl, autoconf, automake, pkgconfig
, perl, flex, bison, readline, libexif
, x11Support ? true, SDL
, svgSupport ? true, inkscape
, asciiArtSupport ? true, aalib
, gifSupport ? true, giflib
, tiffSupport ? true, libtiff
, jpegSupport ? true, libjpeg
, pngSupport ? true, libpng
}:

stdenv.mkDerivation rec {
  name = "fim-${version}";
  version = "0.5rc3";

  src = fetchurl {
    url = mirror://savannah/fbi-improved/fim-0.5-rc3.tar.gz;
    sha256 = "12aka85h469zfj0zcx3xdpan70gq8nf5rackgb1ldcl9mqjn50c2";
  };

  postPatch = ''
   substituteInPlace doc/vim2html.pl \
     --replace /usr/bin/perl ${perl}/bin/perl
  '';

  nativeBuildInputs = [ autoconf automake pkgconfig ];

  buildInputs = with stdenv.lib;
    [ perl flex bison readline libexif ]
    ++ optional x11Support SDL
    ++ optional svgSupport inkscape
    ++ optional asciiArtSupport aalib
    ++ optional gifSupport giflib
    ++ optional tiffSupport libtiff
    ++ optional jpegSupport libjpeg
    ++ optional pngSupport libpng;

  NIX_CFLAGS_COMPILE = stdenv.lib.optional x11Support "-lSDL";

  meta = with stdenv.lib; {
    description = "A lightweight, highly customizable and scriptable image viewer";
    longDescription = ''
      FIM (Fbi IMproved) is a lightweight, console based image viewer that aims
      to be a highly customizable and scriptable for users who are comfortable
      with software like the VIM text editor or the Mutt mail user agent.
    '';
    homepage = http://www.nongnu.org/fbi-improved/;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ primeos ];
  };
}
