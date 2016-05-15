{ stdenv, fetchFromGitHub, cmake, irrlicht, libpng, bzip2, curl, libogg, jsoncpp
, libjpeg, libXxf86vm, mesa, openal, libvorbis, xlibsWrapper, sqlite, luajit
, freetype, gettext, doxygen, ncurses, leveldb
}:

let
  version = "0.4.14";
  sources = {
    src = fetchFromGitHub {
      owner = "minetest";
      repo = "minetest";
      rev = "${version}";
      sha256 = "1f74wsiqj8x1m8wqmxijb00df5ljlvy4ac0ahbh325vfzi0bjla3";
    };
    data = fetchFromGitHub {
      owner = "minetest";
      repo = "minetest_game";
      rev = "${version}";
      sha256 = "1dc9zfbp603h2nlk39bw37kjbswrfmpd9yg3v72z1jb89pcxzsqs";
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
