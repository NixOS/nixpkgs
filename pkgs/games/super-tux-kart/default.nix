{ stdenv, fetchFromGitHub, fetchsvn, cmake, pkgconfig
, openal, freealut, mesa, libvorbis, libogg, gettext, curl, freetype
, fribidi, libtool, bluez, libjpeg, libpng, zlib, libX11, libXrandr }:

let
  dir = "stk-code";

in stdenv.mkDerivation rec {
  name = "supertuxkart-${version}";

  version = "0.9.2";
  srcs = [
    (fetchFromGitHub {
      owner  = "supertuxkart";
      repo   = "stk-code";
      rev    = version;
      sha256 = "1zsc5nw8il8xwppk624jampfk6qhqzjnni8zicrhqix0xg07nxca";
      name   = dir;
    })
    (fetchsvn {
      url    = "https://svn.code.sf.net/p/supertuxkart/code/stk-assets";
      rev    = "16503"; # 0.9.2 crashes with 16937. Refer to stk-code/doc/assets_version
      sha256 = "0j1dy27gxm4hx26xddr2ak6vw0lim0nqmjnszfb4c61y92j12cqp";
      name   = "stk-assets";
    })
  ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    cmake libtool
    libX11 libXrandr
    openal freealut mesa libvorbis libogg gettext zlib freetype
    curl fribidi bluez libjpeg libpng
  ];

  enableParallelBuilding = true;

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
    maintainers = with maintainers; [ c0dehero fuuzetsu peterhoeg ];
    platforms = with platforms; linux;
  };
}
