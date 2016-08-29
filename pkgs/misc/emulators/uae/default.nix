{stdenv, fetchurl, pkgconfig, gtk, alsaLib, SDL}:

stdenv.mkDerivation rec {
  name = "uae-0.8.29";

  src = fetchurl {
    url = "http://web.archive.org/web/20130905032631/http://www.amigaemulator.org/files/sources/develop/${name}.tar.bz2";
    sha256 = "05s3cd1rd5a970s938qf4c2xm3l7f54g5iaqw56v8smk355m4qr4";
  };

  configureFlags = [ "--with-sdl" "--with-sdl-sound" "--with-sdl-gfx" "--with-alsa" ];

  buildInputs = [ pkgconfig gtk alsaLib SDL ];

  hardeningDisable = [ "format" ];

  meta = {
    description = "Ultimate/Unix/Unusable Amiga Emulator";
    license = stdenv.lib.licenses.gpl2Plus;
    homepage = http://web.archive.org/web/20130901222855/http://www.amigaemulator.org/;
    maintainers = [ stdenv.lib.maintainers.sander ];
    platforms = stdenv.lib.platforms.linux;
  };
}
