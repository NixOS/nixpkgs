{
  lib,
  mkDerivation,
  fetchFromGitLab,
  cmake,
  luajit,
  SDL2,
  SDL2_image,
  SDL2_ttf,
  physfs,
  fetchpatch,
  openal,
  libmodplug,
  libvorbis,
  solarus,
  qtbase,
  qttools,
  glm,
}:

mkDerivation rec {
  pname = "solarus-quest-editor";
  version = "1.6.4";

  src = fetchFromGitLab {
    owner = "solarus-games";
    repo = pname;
    rev = "v${version}";
    sha256 = "1qbc2j9kalk7xqk9j27s7wnm5zawiyjs47xqkqphw683idmzmjzn";
  };

  patches = [
    (fetchpatch {
      url = "https://gitlab.com/solarus-games/solarus-quest-editor/-/commit/81d5c7f1602cf355684d70a5e3449fefccfc44b8.patch";
      sha256 = "tVUxkkDp2PcOHGy4dGvUcYj9gF7k4LN21VuxohCw9NE=";
    })
  ];

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    luajit
    SDL2
    SDL2_image
    SDL2_ttf
    physfs
    openal
    libmodplug
    libvorbis
    solarus
    qtbase
    qttools
    glm
  ];

  meta = with lib; {
    description = "The editor for the Zelda-like ARPG game engine, Solarus";
    mainProgram = "solarus-quest-editor";
    longDescription = ''
      Solarus is a game engine for Zelda-like ARPG games written in lua.
      Many full-fledged games have been writen for the engine.
      Games can be created easily using the editor.
    '';
    homepage = "https://www.solarus-games.org";
    license = licenses.gpl3;
    maintainers = [ ];
    platforms = platforms.linux;
  };

}
