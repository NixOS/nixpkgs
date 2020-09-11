{ lib, mkDerivation, fetchFromGitLab, cmake, luajit,
  SDL2, SDL2_image, SDL2_ttf, physfs,
  openal, libmodplug, libvorbis, solarus,
  qtbase, qttools, glm }:

mkDerivation rec {
  pname = "solarus-quest-editor";
  version = "1.6.4";

  src = fetchFromGitLab {
    owner = "solarus-games";
    repo = pname;
    rev = "v${version}";
    sha256 = "1qbc2j9kalk7xqk9j27s7wnm5zawiyjs47xqkqphw683idmzmjzn";
  };
  
  buildInputs = [ cmake luajit SDL2
    SDL2_image SDL2_ttf physfs
    openal libmodplug libvorbis
    solarus qtbase qttools glm ];

  meta = with lib; {
    description = "The editor for the Zelda-like ARPG game engine, Solarus";
    longDescription = ''
      Solarus is a game engine for Zelda-like ARPG games written in lua.
      Many full-fledged games have been writen for the engine.
      Games can be created easily using the editor.
    '';
    homepage = "http://www.solarus-games.org";
    license = licenses.gpl3;
    maintainers = [ maintainers.Nate-Devv ];
    platforms = platforms.linux;
  };
  
}
