{ stdenv, fetchFromGitHub, fetchsvn, cmake, pkgconfig
, openal, freealut, libGLU, libGL, libvorbis, libogg, gettext, curl, freetype
, fribidi, libtool, bluez, libjpeg, libpng, zlib, libX11, libXrandr, enet, harfbuzz }:

let
  dir = "stk-code";

in stdenv.mkDerivation rec {
  pname = "supertuxkart";
  version = "1.1";

  srcs = [
    (fetchFromGitHub {
      owner  = "supertuxkart";
      repo   = "stk-code";
      rev    = version;
      sha256 = "01vxxl94583ixswzmi4caz8dk64r56pn3zxh7v63zml60yfvxbvp";
      name   = dir;
    })
    (fetchsvn {
      url    = "https://svn.code.sf.net/p/supertuxkart/code/stk-assets";
      rev    = "18212";
      sha256 = "1dyj8r5rfifhnhayga8w8irkpa99vw57xjmy74cp8xz8g7zvdzqf";
      name   = "stk-assets";
    })
  ];

  nativeBuildInputs = [ cmake gettext libtool pkgconfig ];

  buildInputs = [
    libX11 libXrandr
    openal freealut libGLU libGL libvorbis libogg zlib freetype
    curl fribidi bluez libjpeg libpng enet harfbuzz
  ];

  enableParallelBuilding = true;

  cmakeFlags = [
    "-DBUILD_RECORDER=OFF"         # libopenglrecorder is not in nixpkgs
    "-DUSE_SYSTEM_ANGELSCRIPT=OFF" # doesn't work with 2.31.2 or 2.32.0
  ];

  sourceRoot = dir;

  meta = with stdenv.lib; {
    description = "A Free 3D kart racing game";
    longDescription = ''
      SuperTuxKart is a Free 3D kart racing game, with many tracks,
      characters and items for you to try, similar in spirit to Mario
      Kart.
    '';
    homepage = https://supertuxkart.net/;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ pyrolagus peterhoeg ];
    platforms = with platforms; linux;
  };
}
