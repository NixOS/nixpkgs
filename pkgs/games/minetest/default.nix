{ stdenv, fetchgit, cmake, irrlicht3843, libpng, bzip2,
  libjpeg, libXxf86vm, mesa, openal, libvorbis, x11 }:

let
  version = "0.4.4";
  sources = {
    src = fetchgit {
      url = "https://github.com/celeron55/minetest.git";
      rev = "ab06fca4bed26f3dc97d5e5cff437d075d7acff8";
    };
    data = fetchgit {
      url = "https://github.com/celeron55/minetest_game.git";
      rev = "3928eccf74af0288d12ffb14f8222fae479bc06b";
    };
  };
in stdenv.mkDerivation {
  name = "minetest-${version}";

  src = sources.src;

  cmakeFlags = [
    "-DIRRLICHT_INCLUDE_DIR=${irrlicht3843}/include/irrlicht"
  ];

  buildInputs = [
    cmake irrlicht3843 libpng bzip2 libjpeg
    libXxf86vm mesa openal libvorbis x11
  ];

  postInstall = ''
    mkdir -pv $out/share/minetest/games/minetest_game/
    cp -rv ${sources.data}/* $out/share/minetest/games/minetest_game/
  '';

  meta = {
    homepage = "http://minetest.net/";
    description = "Infinite-world block sandbox game";
    license = "LGPLv2.1+";
  };
}
