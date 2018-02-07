{ lib, stdenv, fetchFromGitHub, SDL2, SDL2_image, pkgconfig
, libvorbis, mesa_noglu, boost, cmake }:


stdenv.mkDerivation rec {
  name = "commandergenius-${version}";
  version = "1822release";

  src = fetchFromGitHub {
    owner = "gerstrong";
    repo = "Commander-Genius";
    rev = "v${version}";
    sha256 = "07vxg8p1dnnkajzs5nifxpwn4mdd1hxsw05jl25gvaimpl9p2qc8";
  };

  buildInputs = [ SDL2 SDL2_image mesa_noglu boost libvorbis ];

  nativeBuildInputs = [ cmake pkgconfig ];

  postPatch = ''
    NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE $(sdl2-config --cflags)"
    sed -i 's,APPDIR games,APPDIR bin,' src/install.cmake
  '';

  meta = with stdenv.lib; {
    description = "Modern Interpreter for the Commander Keen Games";
    longDescription = ''
      Commander Genius is an open-source clone of
      Commander Keen which allows you to play
      the games, and some of the mods
      made for it. All of the original data files
      are required to do so
    '';
    homepage = https://github.com/gerstrong/Commander-Genius;
    maintainers = with maintainers; [ hce ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
