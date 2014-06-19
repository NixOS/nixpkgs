{stdenv, fetchurl, pkgconfig, gtk, alsaLib, SDL}:

stdenv.mkDerivation {
  name = "uae-0.8.29";
  src = fetchurl {
    url = http://www.amigaemulator.org/files/sources/develop/uae-0.8.29.tar.bz2;
    sha256 = "05s3cd1rd5a970s938qf4c2xm3l7f54g5iaqw56v8smk355m4qr4";
  };
  configureFlags = [ "--with-sdl" "--with-sdl-sound" "--with-sdl-gfx" "--with-alsa" ];
  buildInputs = [ pkgconfig gtk alsaLib SDL ];
  
  meta = {
    description = "Ultimate/Unix/Unusuable Amiga Emulator";
    license = stdenv.lib.licenses.gpl2Plus;
    homepage = http://www.amigaemulator.org;
    maintainers = [ stdenv.lib.maintainers.sander ];
  };
}
