{ stdenv, fetchFromGitLab, cmake, luajit,
  SDL2, SDL2_image, SDL2_ttf, physfs,
  openal, libmodplug, libvorbis,
  qtbase, qttools }:

stdenv.mkDerivation rec {
  name = "solarus-${version}";
  version = "1.5.3";

  src = fetchFromGitLab {
    owner = "solarus-games";
    repo = "solarus";
    rev = "v1.5.3";
    sha256 = "035hkdw3a1ryasj5wfa1xla1xmpnc3hjp4s20sl9ywip41675vaz";
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
