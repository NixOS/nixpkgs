{ stdenv, fetchurl, pkgconfig
, gettext, gtk, SDL, zlib, glib, openal, mesa, lua, freetype }:

with stdenv.lib;
stdenv.mkDerivation rec{

  name = "fs-uae-${version}";
  version = "2.4.3";

  src = fetchurl {
    urls = [ "http://fs-uae.net/fs-uae/stable/${version}/${name}.tar.gz" ];
    sha256 = "05wngvpqj8kj4wzi5jzzhvs19iljb3m6ba1l2hk4rz68b400ndv6";
  };

  buildInputs = [ pkgconfig gettext gtk SDL zlib glib openal mesa lua freetype ];

  phases = "unpackPhase buildPhase installPhase";

  # Strange: the docs recommend SDL2, but it does compile only with SDL1
  buildPhase = "make sdl=1";
  installPhase = "make install prefix=$out";

  meta = {
    description = "An accurate, customizable Amiga Emulator";
    longDescription = ''
      FS-UAE integrates the most accurate Amiga emulation code available
      from WinUAE. FS-UAE emulates A500, A500+, A600, A1200, A1000, A3000
      and A4000 models, but you can tweak the hardware configuration and
      create customized Amigas.
    '';
    license = licenses.gpl2Plus;
    homepage = http://fs-uae.net;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = stdenv.lib.platforms.linux;
  };
}
# TODO: testing and Python GUI support
# TODO: SDL2 support
