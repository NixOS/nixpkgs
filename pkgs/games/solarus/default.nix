{ lib, mkDerivation, fetchFromGitLab, cmake, luajit
,  SDL2, SDL2_image, SDL2_ttf, physfs, glm
, openal, libmodplug, libvorbis
, qtbase, qttools }:

mkDerivation rec {
  pname = "solarus";
  version = "1.6.5";

  src = fetchFromGitLab {
    owner = "solarus-games";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-LaJKpvwKiN/k2bZuZCNG7v5sYRBGOJfToGJLePFryVs=";
  };

  outputs = [ "out" "lib" "dev" ];

  nativeBuildInputs = [ cmake qttools ];
  buildInputs = [ luajit SDL2
    SDL2_image SDL2_ttf physfs
    openal libmodplug libvorbis
    qtbase glm ];


  meta = with lib; {
    description = "A Zelda-like ARPG game engine";
    longDescription = ''
      Solarus is a game engine for Zelda-like ARPG games written in lua.
      Many full-fledged games have been writen for the engine.
    '';
    homepage = "https://www.solarus-games.org";
    license = licenses.gpl3;
    maintainers = [ ];
    platforms = platforms.linux;
  };

}
