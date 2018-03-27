{ stdenv, fetchurl, pkgconfig
, gettext, gtk2, SDL2, zlib, glib, openal, libGLU_combined, lua, freetype, libmpeg2, zip }:

with stdenv.lib;
stdenv.mkDerivation rec {

  name = "fs-uae-${version}";
  version = "2.8.3";

  src = fetchurl {
    url = "https://fs-uae.net/fs-uae/stable/${version}/${name}.tar.gz";
    sha256 = "14k2p324sdr662f49299mv0bw5jmpj1i2iqn0xs5pgf80x6l3mg2";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gettext gtk2 SDL2 zlib glib openal libGLU_combined lua freetype libmpeg2 zip ];

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
    maintainers = with stdenv.lib; [ maintainers.AndersonTorres ];
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
# TODO: testing and Python GUI support
