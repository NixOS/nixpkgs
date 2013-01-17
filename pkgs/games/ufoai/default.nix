{stdenv, fetchurl, SDL, mesa, SDL_image, SDL_ttf, SDL_mixer, libpng, libjpeg, zlib
, curl, libvorbis, libtheora, xvidcore, pkgconfig, gtk, glib, libxml2, gtksourceview
, gtkglext, openal, gettext, p7zip }:

stdenv.mkDerivation rec {
  name = "ufoai-2.3";
  src = fetchurl {
    url = mirror://sourceforge/ufoai/ufoai-2.3-source.tar.bz2;
    sha256 = "1pb41q5wx180l6xv8gm1sw8b7cji42znnb6qpjaap6vpgc8k3hp9";
  };

  srcData = fetchurl {
    url = mirror://sourceforge/ufoai/ufoai-2.3-data.tar;
    sha256 = "0952kx6cbi4y89fbz1ig32rvsmfhzqpvdf79rq4axag9d3i5qlqf";
  };

  srcI18n = fetchurl {
    url = mirror://sourceforge/ufoai/ufoai-2.3-i18n.tar.bz2;
    sha256 = "14fzv8a4xng6kfl6aw8yzz6vl2j5vryxija5b2yz75jbfpa94i09";
  };

  # for the xvidcore static lib
  NIX_CFLAGS_COMPILE = "-pthread -lm";

  # Order is important, x libs include a libpng version that fails for ufoai
  buildInputs = [ libpng SDL mesa SDL_image SDL_ttf SDL_mixer libjpeg zlib curl libvorbis
    libtheora xvidcore pkgconfig glib gtk gtkglext gtksourceview libxml2 openal gettext
    p7zip ];

  enableParallelBuilding = true;

  preConfigure = ''
    tar xvf $srcI18n
  '';

  configureFlags = "--enable-release";

  postInstall = ''
    pushd $out/share/ufoai
    tar xvf $srcData
    popd
  '';

  installTargets = "install_exec";

  meta = {
    homepage = http://www.ultimatestunts.nl/;
    description = "Squad-based tactical strategy game in the tradition of X-Com";
    license = "GPLv2+";
    maintainers = with stdenv.lib.maintainers; [viric];
    #platforms = stdenv.lib.platforms.linux;
  };
}
