{ stdenv, fetchFromGitHub, cmake
, freetype, SDL2, SDL2_mixer, openal, zlib, libpng, python, libvorbis
, libiconv }:

stdenv.mkDerivation rec {
  pname = "gemrb";
  version = "0.8.6";

  src = fetchFromGitHub {
    owner  = "gemrb";
    repo   = "gemrb";
    rev    = "v${version}";
    sha256 = "0vsr3fsqmv9b7s5l0cwhpq2pf7ah2wvgmcn9y8asj6w8hprp17d4";
  };

  # TODO: make libpng, libvorbis, sdl_mixer, freetype, vlc, glew (and other gl reqs) optional
  buildInputs = [ freetype python openal SDL2 SDL2_mixer zlib libpng libvorbis libiconv ];

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
    maintainers = with maintainers; [ peterhoeg ];
    platforms = platforms.all;
  };
}
