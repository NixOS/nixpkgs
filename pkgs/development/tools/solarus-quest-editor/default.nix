{ stdenv, fetchFromGitHub, cmake, luajit,
  SDL2, SDL2_image, SDL2_ttf, physfs,
  openal, libmodplug, libvorbis, solarus,
  qtbase, qttools }:

stdenv.mkDerivation rec {
  name = "solarus-quest-editor-${version}";
  version = "1.4.5";
    
  src = fetchFromGitHub {
    owner = "christopho";
    repo = "solarus-quest-editor";
    rev = "61f0fa7a5048994fcd9c9f3a3d1255d0be2967df";
    sha256 = "1fpq55nvs5k2rxgzgf39c069rmm73vmv4gr5lvmqzgsz07rkh07f";
  };
  
  buildInputs = [ cmake luajit SDL2
    SDL2_image SDL2_ttf physfs
    openal libmodplug libvorbis
    solarus qtbase qttools ];
    
  patches = [ ./patches/fix-install.patch ];

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
