{ stdenv, fetchFromGitHub, fetchsvn, fetchpatch, cmake, pkgconfig
, openal, freealut, libGLU_combined, libvorbis, libogg, gettext, curl, freetype
, fribidi, libtool, bluez, libjpeg, libpng, zlib, libX11, libXrandr }:

let
  dir = "stk-code";

in stdenv.mkDerivation rec {
  name = "supertuxkart-${version}";

  version = "0.9.3";

  srcs = [
    (fetchFromGitHub {
      owner  = "supertuxkart";
      repo   = "stk-code";
      rev    = version;
      sha256 = "1smnanjjaj4yq2ywikv0l6xysh6n2h1cm549plbg5xdk9mx2sfia";
      name   = dir;
    })
    (fetchsvn {
      url    = "https://svn.code.sf.net/p/supertuxkart/code/stk-assets";
      rev    = "17448";
      sha256 = "0lxbb4k57gv4gj12l5hnvhwdycpzcxjwg7qdfwglj2bdvaxf9f21";
      name   = "stk-assets";
    })
  ];

  nativeBuildInputs = [ cmake gettext libtool pkgconfig ];

  buildInputs = [
    libX11 libXrandr
    openal freealut libGLU_combined libvorbis libogg zlib freetype
    curl fribidi bluez libjpeg libpng
  ];

  # https://github.com/supertuxkart/stk-code/issues/3557#issuecomment-440794379
  patches = [
    (fetchpatch {
      url = "https://github.com/supertuxkart/stk-code/commit/3a3953f38c3555e87f3608d0291dbfccf34e9775.patch";
      sha256 = "13mr5pwf45g7frpxzlxiyiq39qi3z9spd7l6gi8i3dr3li9wrb1k";
    })
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
    maintainers = with maintainers; [ c0dehero fuuzetsu peterhoeg ];
    platforms = with platforms; linux;
  };
}
