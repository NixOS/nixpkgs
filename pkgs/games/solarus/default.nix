{ stdenv, fetchFromGitLab, cmake, luajit,
  SDL2, SDL2_image, SDL2_ttf, physfs,
  openal, libmodplug, libvorbis,
  qtbase, qttools }:

stdenv.mkDerivation rec {
  name = "solarus-${version}";
  version = "1.6.0";

  src = fetchFromGitLab {
    owner = "solarus-games";
    repo = "solarus";
    rev = "v1.6.0";
    sha256 = "0mlpa1ijaxy84f7xjgs2kjnpm035b8q9ckva6lg14q49gzy10fr2";
  };

  buildInputs = [ cmake luajit SDL2
    SDL2_image SDL2_ttf physfs
    openal libmodplug libvorbis
    qtbase qttools ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A Zelda-like ARPG game engine";
    longDescription = ''
      Solarus is a game engine for Zelda-like ARPG games written in lua.
      Many full-fledged games have been writen for the engine.
    '';
    homepage = http://www.solarus-games.org;
    license = licenses.gpl3;
    maintainers = [ maintainers.Nate-Devv ];
    platforms = platforms.linux;
  };

}
