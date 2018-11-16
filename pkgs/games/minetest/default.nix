{ stdenv, fetchFromGitHub, cmake, irrlicht, libpng, bzip2, curl, libogg, jsoncpp
, libjpeg, libXxf86vm, libGLU_combined, openal, libvorbis, xlibsWrapper, sqlite, luajit
, freetype, gettext, doxygen, ncurses, leveldb
}:

let
  version = "0.4.17";
  sources = {
    src = fetchFromGitHub {
      owner = "minetest";
      repo = "minetest";
      rev = "${version}";
      sha256 = "0ri9hyhvcnyyy2k83qvv543s10476g9fn3vcbjwvxjfqap9mkc5m";
    };
    data = fetchFromGitHub {
      owner = "minetest";
      repo = "minetest_game";
      rev = "${version}";
      sha256 = "1g8iw2pya32ifljbdx6z6rpcinmzm81i9minhi2bi1d500ailn7s";
    };
  };
in stdenv.mkDerivation {
  name = "minetest-${version}";

  src = sources.src;

  cmakeFlags = [
    "-DENABLE_FREETYPE=1"
    "-DENABLE_GETTEXT=1"
    "-DENABLE_SYSTEM_JSONCPP=1"
    "-DGETTEXT_INCLUDE_DIR=${gettext}/include/gettext"
    "-DCURL_INCLUDE_DIR=${curl.dev}/include/curl"
    "-DIRRLICHT_INCLUDE_DIR=${irrlicht}/include/irrlicht"
  ];

  NIX_CFLAGS_COMPILE = [ "-DluaL_reg=luaL_Reg" ]; # needed since luajit-2.1.0-beta3

  buildInputs = [
    cmake irrlicht libpng bzip2 libjpeg curl libogg jsoncpp libXxf86vm libGLU_combined
    openal libvorbis xlibsWrapper sqlite luajit freetype gettext doxygen ncurses
    leveldb
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
