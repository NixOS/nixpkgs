{ stdenv, fetchFromGitHub, cmake
, freetype, SDL2, SDL2_mixer, openal, zlib, libpng, python, libvorbis }:

stdenv.mkDerivation rec {
  name = "gemrb-${version}";
  version = "0.8.5";

  src = fetchFromGitHub {
    owner  = "gemrb";
    repo   = "gemrb";
    rev    = "v${version}";
    sha256 = "0xkjsiawxz53rac26vqz9sfgva0syff8x8crabrpbpxgmbacih7a";
  };

  # TODO: make libpng, libvorbis, sdl_mixer, freetype, vlc, glew (and other gl reqs) optional
  buildInputs = [ freetype python openal SDL2 SDL2_mixer zlib libpng libvorbis ];

  nativeBuildInputs = [ cmake ];

  enableParallelBuilding = true;

  cmakeFlags = [
    "-DLAYOUT=opt"
  ];

  meta = with stdenv.lib; {
    description = "A reimplementation of the Infinity Engine, used by games such as Baldur's Gate";
    longDescription = ''
      GemRB (Game engine made with pre-Rendered Background) is a portable
      open-source implementation of Bioware's Infinity Engine. It was written to
      support pseudo-3D role playing games based on the Dungeons & Dragons
      ruleset (Baldur's Gate and Icewind Dale series, Planescape: Torment).
    '';
    homepage = http://gemrb.org/;
    license = licenses.gpl2;
    maintainer = with maintainers; [ peterhoeg ];
    platforms = platforms.all;
  };
}
