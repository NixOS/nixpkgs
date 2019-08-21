{ stdenv, fetchFromGitLab, cmake, luajit,
  SDL2, SDL2_image, SDL2_ttf, physfs,
  openal, libmodplug, libvorbis,
  qtbase, qttools }:

stdenv.mkDerivation rec {
  name = "solarus-${version}";
  version = "1.6.1";

  src = fetchFromGitLab {
    owner = "solarus-games";
    repo = "solarus";
    rev = "v1.6.1";
    sha256 = "02jk5lr45jnd1bmw9lgicardhx12iq3dx3xzx4ny731b417riavk";
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
