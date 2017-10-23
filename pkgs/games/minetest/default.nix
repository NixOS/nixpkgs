{ stdenv, fetchFromGitHub, cmake, irrlicht, libpng, bzip2, curl, libogg, jsoncpp
, libjpeg, libXxf86vm, mesa, openal, libvorbis, xlibsWrapper, sqlite, luajit
, freetype, gettext, doxygen, ncurses, leveldb
}:

let
  version = "0.4.15";
  sources = {
    src = fetchFromGitHub {
      owner = "minetest";
      repo = "minetest";
      rev = "${version}";
      sha256 = "0bn4102d0hq774bn6hqhrs6qzl4sancrs4j15w4318bqdndk4676";
    };
    data = fetchFromGitHub {
      owner = "minetest";
      repo = "minetest_game";
      rev = "${version}";
      sha256 = "1mjj40slfiw0khg9nrq8yfmnay237z5jm1cg9hrsiq2fkjrr8w2m";
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
    cmake irrlicht libpng bzip2 libjpeg curl libogg jsoncpp libXxf86vm mesa
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
