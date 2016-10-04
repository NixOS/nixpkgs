{ fetchgit, fetchsvn, cmake, stdenv, plib, SDL, openal, freealut, mesa
, libvorbis, libogg, gettext, libXxf86vm, curl, pkgconfig
, fribidi, autoconf, automake, libtool, bluez, libjpeg, libpng }:

stdenv.mkDerivation rec {
  name = "supertuxkart-${version}";

  version = "0.9";
  srcs = [
    (fetchgit {
      url = "https://github.com/supertuxkart/stk-code";
      rev = "28a525f6d4aba2667c41a549b027149fcceda97e";
      sha256 = "0b5izr7j3clm6pcxanwwaas06f17wi454s6hwmgv1mg48aay2v97";
      name = "stk-code";
    })
    (fetchsvn {
      url = "https://svn.code.sf.net/p/supertuxkart/code/stk-assets";
      rev = "16293";
      sha256 = "07jdkli28xr3rcxvixyy5bwi26n5i7dkhd9q0j4wifgs4pymm8r5";
      name = "stk-assets";
    })
  ];
  
  buildInputs = [
    plib SDL openal freealut mesa libvorbis libogg gettext
    libXxf86vm curl pkgconfig fribidi autoconf automake libtool cmake bluez libjpeg libpng
  ];

  enableParallelBuilding = true;

  sourceRoot = "stk-code";

  meta = {
    description = "A Free 3D kart racing game";
    longDescription = ''
      SuperTuxKart is a Free 3D kart racing game, with many tracks,
      characters and items for you to try, similar in spirit to Mario
      Kart.
    '';
    homepage = http://supertuxkart.sourceforge.net/;
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [ c0dehero fuuzetsu ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
