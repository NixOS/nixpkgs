{ lib, stdenv, fetchFromGitHub, fetchsvn, cmake, pkgconfig, makeWrapper
, openal, freealut, libGLU, libGL, libvorbis, libogg, gettext, curl, freetype, glew
, fribidi, libtool, bluez, libjpeg, libpng, zlib, libX11, libXrandr, harfbuzz
, mcpp, wiiuse, angelscript
}:
let
  dir = "stk-code";
  assets = fetchsvn {
    url    = "https://svn.code.sf.net/p/supertuxkart/code/stk-assets";
    rev    = "18212";
    sha256 = "1dyj8r5rfifhnhayga8w8irkpa99vw57xjmy74cp8xz8g7zvdzqf";
    name   = "stk-assets";
  };

  # List of bundled libraries in stk-code/lib to keep
  # Those are the libraries that cannot be replaced
  # with system packages.
  bundledLibraries = [
    # Bullet 2.87 is incompatible (bullet 2.79 needed whereas 2.87 is packaged)
    # The api changed in a lot of classes, too much work to adapt
    "bullet"
    # Upstream Libenet doesn't yet support IPv6,
    # So we will use the bundled libenet which
    # has been fixed to support it.
    "enet"
    # Internal library of STK, nothing to do about it
    "graphics_utils"
    # This irrlicht is bundled with cmake
    # whereas upstream irrlicht still uses
    # archaic Makefiles, too complicated to switch to.
    "irrlicht"
    # Not packaged to this date
    "libraqm"
    # Not packaged to this date
    "libsquish"
  ];
in stdenv.mkDerivation rec {

  pname = "supertuxkart";
  version = "1.1";

  src = fetchFromGitHub {
    owner  = "supertuxkart";
    repo   = "stk-code";
    rev    = version;
    sha256 = "01vxxl94583ixswzmi4caz8dk64r56pn3zxh7v63zml60yfvxbvp";
    name   = dir;
  };

  # Deletes all bundled libs in stk-code/lib except those
  # That couldn't be replaced with system packages
  postPatch = ''
    find lib -maxdepth 1 -type d | egrep -v "^lib$|${(lib.concatStringsSep "|" bundledLibraries)}" | xargs -n1 -L1 -r -I{} rm -rf {}
  '';

  nativeBuildInputs = [ cmake gettext libtool pkgconfig makeWrapper ];

  buildInputs = [
    libX11 libXrandr
    openal freealut libGLU libGL libvorbis libogg zlib freetype glew
    curl fribidi bluez libjpeg libpng harfbuzz
    mcpp wiiuse angelscript
  ];

  cmakeFlags = [
    "-DBUILD_RECORDER=OFF"         # libopenglrecorder is not in nixpkgs
    "-DUSE_SYSTEM_ANGELSCRIPT=OFF" # doesn't work with 2.31.2 or 2.32.0
    "-DCHECK_ASSETS=OFF"
    "-DUSE_SYSTEM_WIIUSE=ON"
    "-DUSE_SYSTEM_ANGELSCRIPT=ON"
  ];

  # Obtain the assets directly from the fetched store path, to avoid duplicating assets across multiple engine builds
  preFixup = ''
    wrapProgram $out/bin/supertuxkart --set-default SUPERTUXKART_ASSETS_DIR "${assets}"
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "A Free 3D kart racing game";
    longDescription = ''
      SuperTuxKart is a Free 3D kart racing game, with many tracks,
      characters and items for you to try, similar in spirit to Mario
      Kart.
    '';
    homepage = "https://supertuxkart.net/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ pyrolagus peterhoeg ];
    platforms = with platforms; linux;
  };
}
