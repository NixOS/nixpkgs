{ lib, mkDerivation, fetchFromGitLab, cmake, luajit
,  SDL2, SDL2_image, SDL2_ttf, physfs, glm
, openal, libmodplug, libvorbis
, qtbase, qttools }:

mkDerivation rec {
  pname = "solarus";
  version = "1.6.4";

  src = fetchFromGitLab {
    owner = "solarus-games";
    repo = pname;
    rev = "v${version}";
    sha256 = "sbdlf+R9OskDQ5U5rqUX2gF8l/fj0sDJv6BL7H1I1Ng=";
  };

  outputs = [ "out" "lib" "dev" ];

  nativeBuildInputs = [ cmake qttools ];
  buildInputs = [ luajit SDL2
    SDL2_image SDL2_ttf physfs
    openal libmodplug libvorbis
    qtbase glm ];

  preFixup = ''
    mkdir $lib/
    mv $out/lib $lib
  '';

  meta = with lib; {
    description = "A Zelda-like ARPG game engine";
    longDescription = ''
      Solarus is a game engine for Zelda-like ARPG games written in lua.
      Many full-fledged games have been writen for the engine.
    '';
    homepage = "http://www.solarus-games.org";
    license = licenses.gpl3;
    maintainers = [ ];
    platforms = platforms.linux;
  };

}
