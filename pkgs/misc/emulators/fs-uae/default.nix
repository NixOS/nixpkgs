{ stdenv, fetchurl, pkgconfig
, gettext, gtk2, SDL2, zlib, glib, openal, libGLU, libGL, lua, freetype, libmpeg2, zip }:

with stdenv.lib;
stdenv.mkDerivation rec {

  pname = "fs-uae";
  version = "3.0.3";

  src = fetchurl {
    url = "https://fs-uae.net/stable/${version}/${pname}-${version}.tar.gz";
    sha256 = "0v5c8ns00bam4myj7454hpkrnm9i81jwdzrp5nl7gaa18qb60hjq";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gettext gtk2 SDL2 zlib glib openal libGLU libGL lua freetype libmpeg2 zip ];

  meta = {
    description = "An accurate, customizable Amiga Emulator";
    longDescription = ''
      FS-UAE integrates the most accurate Amiga emulation code available
      from WinUAE. FS-UAE emulates A500, A500+, A600, A1200, A1000, A3000
      and A4000 models, but you can tweak the hardware configuration and
      create customized Amigas.
    '';
    license = licenses.gpl2Plus;
    homepage = "https://fs-uae.net";
    maintainers = with stdenv.lib; [ maintainers.AndersonTorres ];
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
# TODO: testing and Python GUI support
