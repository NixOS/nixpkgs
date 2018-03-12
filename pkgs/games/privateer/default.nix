{ stdenv, fetchsvn, boost, cmake, ffmpeg, freeglut, glib,
  gtk2, libjpeg, libpng, libpthreadstubs, libvorbis, libXau, libXdmcp,
  libXmu, libGLU_combined, openal, pixman, pkgconfig, python27, SDL }:

stdenv.mkDerivation {
  name = "privateer-1.03";

  src = fetchsvn {
    #url = "mirror://sourceforge/project/privateer/Wing%20Commander%20Privateer/Privateer%20Gemini%20Gold%201.03/PrivateerGold1.03.bz2.bin";
    url = "https://privateer.svn.sourceforge.net/svnroot/privateer/privgold/trunk/engine";
    rev = 294;
    sha256 = "e1759087d4565d3fc95e5c87d0f6ddf36b2cd5befec5695ec56ed5f3cd144c63";
  };

  buildInputs =
    [ boost cmake ffmpeg freeglut glib gtk2 libjpeg libpng
      libpthreadstubs libvorbis libXau libXdmcp libXmu libGLU_combined openal
      pixman pkgconfig python27 SDL ];

  patches = [ ./0001-fix-VSFile-constructor.patch ];

  preConfigure = ''
    NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE $(pkg-config --cflags gtk+-2.0)"
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp vegastrike $out/bin
    cp vegaserver $out/bin
  '';

  meta = with stdenv.lib; {
    homepage = http://privateer.sourceforge.net/;
    description = "Adventure space flight simulation computer game";
    license = licenses.gpl2Plus; # and a special license for art data
    # https://sourceforge.net/p/privateer/code/HEAD/tree/privgold/trunk/data/art-license.txt

    maintainers = with maintainers; [ chaoflow ];
    platforms = with platforms; linux ++ darwin;
    hydraPlatforms = [];
    broken = true; # it won't build
  };
}
