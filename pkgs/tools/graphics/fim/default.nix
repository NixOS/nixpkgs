{ gcc9Stdenv, fetchurl, autoconf, automake, pkg-config, lib
, perl, flex, bison, readline, libexif
, x11Support ? true, SDL
, svgSupport ? true, inkscape
, asciiArtSupport ? true, aalib
, gifSupport ? true, giflib
, tiffSupport ? true, libtiff
, jpegSupport ? true, libjpeg
, pngSupport ? true, libpng
}:

gcc9Stdenv.mkDerivation rec {
  pname = "fim";
  version = "0.7";

  src = fetchurl {
    url = "mirror://savannah/fbi-improved/${pname}-${version}-trunk.tar.gz";
    sha256 = "sha256-/p7bjeZM46DJOQ9sgtebhkNpBPj2RJYY3dMXhzHnNmg=";
  };

  postPatch = ''
   substituteInPlace doc/vim2html.pl \
     --replace /usr/bin/perl ${perl}/bin/perl
  '';

  nativeBuildInputs = [ autoconf automake pkg-config ];

  buildInputs = with lib;
    [ perl flex bison readline libexif ]
    ++ optional x11Support SDL
    ++ optional svgSupport inkscape
    ++ optional asciiArtSupport aalib
    ++ optional gifSupport giflib
    ++ optional tiffSupport libtiff
    ++ optional jpegSupport libjpeg
    ++ optional pngSupport libpng;

  env.NIX_CFLAGS_COMPILE = lib.optionalString x11Support "-lSDL";

  meta = with lib; {
    description = "A lightweight, highly customizable and scriptable image viewer";
    longDescription = ''
      FIM (Fbi IMproved) is a lightweight, console based image viewer that aims
      to be a highly customizable and scriptable for users who are comfortable
      with software like the VIM text editor or the Mutt mail user agent.
    '';
    homepage = "https://www.nongnu.org/fbi-improved/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ primeos ];
  };
}
