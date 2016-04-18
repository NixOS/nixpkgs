{ stdenv, fetchgit, cmake, irrlicht, libpng, bzip2, curl, libogg, jsoncpp
, libjpeg, libXxf86vm, mesa, openal, libvorbis, xlibsWrapper, sqlite, luajit, freetype
, gettext, doxygen
}:

let
  version = "0.4.13";
  sources = {
    src = fetchgit {
      url = "https://github.com/minetest/minetest.git";
      rev = "d44fceac7e1237b00c6431ee1bb5805b602d0dcd";
      sha256 = "034w9nv23ncdwbs4arzxfph60cfgvalh27hxprjassmz8p7ixnra";
    };
    data = fetchgit {
      url = "https://github.com/minetest/minetest_game.git";
      rev = "2392842948b114670334eabbb593b66e1427747c";
      sha256 = "0wb8rdqc2ghi66k8bm8w2db0w7k5rsbdld0dyj1wdr3d6x0bpkcr";
    };
  };
in stdenv.mkDerivation {
  name = "minetest-${version}";

  src = sources.src;

  cmakeFlags = [
    "-DENABLE_FREETYPE=1"
    "-DENABLE_GETTEXT=1"
    "-DGETTEXT_INCLUDE_DIR=${gettext}/include/gettext"
    "-DCURL_INCLUDE_DIR=${curl.dev}/include/curl"
    "-DIRRLICHT_INCLUDE_DIR=${irrlicht}/include/irrlicht"
  ];

  buildInputs = [
    cmake irrlicht libpng bzip2 libjpeg curl libogg jsoncpp libXxf86vm mesa
    openal libvorbis xlibsWrapper sqlite luajit freetype gettext doxygen
  ];

  postInstall = ''
    mkdir -pv $out/share/minetest/games/minetest_game/
    cp -rv ${sources.data}/* $out/share/minetest/games/minetest_game/
  '';

  meta = with stdenv.lib; {
    homepage = http://minetest.net/;
    description = "Infinite-world block sandbox game";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jgeerds c0dehero ];
  };
}
