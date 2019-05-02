{ stdenv, fetchFromGitLab, cmake, luajit,
  SDL2, SDL2_image, SDL2_ttf, physfs,
  openal, libmodplug, libvorbis, solarus,
  qtbase, qttools, fetchpatch, glm }:

stdenv.mkDerivation rec {
  name = "solarus-quest-editor-${version}";
  version = "1.6.0";
    
  src = fetchFromGitLab {
    owner = "solarus-games";
    repo = "solarus-quest-editor";
    rev = "v${version}";
    sha256 = "1a7816kaljfh9ynzy9g36mqzzv2p800nnbrja73q6vjfrsv3vq4c";
  };
  
  buildInputs = [ cmake luajit SDL2
    SDL2_image SDL2_ttf physfs
    openal libmodplug libvorbis
    solarus qtbase qttools glm ];

  meta = with stdenv.lib; {
    description = "The editor for the Zelda-like ARPG game engine, Solarus";
    longDescription = ''
      Solarus is a game engine for Zelda-like ARPG games written in lua.
      Many full-fledged games have been writen for the engine.
      Games can be created easily using the editor.
    '';
    homepage = http://www.solarus-games.org;
    license = licenses.gpl3;
    maintainers = [ maintainers.Nate-Devv ];
    platforms = platforms.linux;
  };
  
}
