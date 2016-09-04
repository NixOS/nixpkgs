{ stdenv, fetchFromGitHub, cmake, luajit,
  SDL2, SDL2_image, SDL2_ttf, physfs,
  openal, libmodplug, libvorbis}:

stdenv.mkDerivation rec {
  name = "solarus-${version}";
  version = "1.4.5";
    
  src = fetchFromGitHub {
    owner = "christopho";
    repo = "solarus";
    rev = "d9fdb9fdb4e1b9fc384730a9279d134ae9f2c70e";
    sha256 = "0xjx789d6crm322wmkqyq9r288vddsha59yavhy78c4r01gs1p5v";
  };
  
  buildInputs = [ cmake luajit SDL2
    SDL2_image SDL2_ttf physfs
    openal libmodplug libvorbis ];

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
