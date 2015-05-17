{ stdenv, fetchgit, cmake, irrlicht, libpng, bzip2, curl, libogg, jsoncpp,
  libjpeg, libXxf86vm, mesa, openal, libvorbis, x11, sqlite }:

let
  version = "0.4.12";
  sources = {
    src = fetchgit {
      url = "https://github.com/minetest/minetest.git";
      rev = "7993a403f2c17a215e4895ba1848aaf69bb61980";
      sha256 = "04v6fd9r9by8g47xbjzkhkgac5zpik01idngbbx2in4fxrg3ac7c";
    };
    data = fetchgit {
      url = "https://github.com/minetest/minetest_game.git";
      rev = "03c00a831d5c2fd37096449bee49557879068af1";
      sha256 = "1qqhlfz296rmi3mmlvq1rwv7hq5w964w1scry095xaih7y11ycmk";
    };
  };
in stdenv.mkDerivation {
  name = "minetest-${version}";

  src = sources.src;

  cmakeFlags = [
    "-DIRRLICHT_INCLUDE_DIR=${irrlicht}/include/irrlicht"
  ];

  buildInputs = [
    cmake irrlicht libpng bzip2 libjpeg curl libogg jsoncpp
    libXxf86vm mesa openal libvorbis x11 sqlite
  ];

  postInstall = ''
    mkdir -pv $out/share/minetest/games/minetest_game/
    cp -rv ${sources.data}/* $out/share/minetest/games/minetest_game/
  '';

  meta = {
    homepage = "http://minetest.net/";
    description = "Infinite-world block sandbox game";
    license = stdenv.lib.licenses.lgpl21Plus;
  };
}
