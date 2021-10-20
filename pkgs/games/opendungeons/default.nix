{ lib, stdenv, fetchFromGitHub, ogre, cegui, boost, sfml, openal, cmake, ois, pkg-config }:

stdenv.mkDerivation rec {
  pname = "opendungeons";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "OpenDungeons";
    repo = "OpenDungeons";
    rev = version;
    sha256 = "0nipb2h0gn628yxlahjgnfhmpfqa19mjdbj3aqabimdfqds9pryh";
  };

  patches = [ ./cmakepaths.patch ];

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ ogre cegui boost sfml openal ois ];
  NIX_LDFLAGS = "-lpthread";

  meta = with lib; {
    description = "An open source, real time strategy game sharing game elements with the Dungeon Keeper series and Evil Genius";
    homepage = "https://opendungeons.github.io";
    license = with licenses; [ gpl3Plus zlib mit cc-by-sa-30 cc0 ofl cc-by-30 ];
    platforms = platforms.linux;
  };
}
