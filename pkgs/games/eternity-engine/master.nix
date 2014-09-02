{ stdenv, cmake, mesa, SDL, SDL_mixer, SDL_net, fetchgit }:

stdenv.mkDerivation rec {
  name = "eternity-engine-20140902";
  src = fetchgit {
    url = git://github.com/team-eternity/eternity.git;
    rev = "db21379abb33f6d92dc0e1665e527e4d49acc722";
    sha256 = "0k54yvxqxnd60az21b734ka3myxkqb7pjmdp3klrkfwp1kl02ysc";
  };

  cmakeFlags = ''
    -DCMAKE_BUILD_TYPE=Release
  '';

  buildInputs = [ stdenv cmake mesa SDL SDL_mixer SDL_net ];

  enableParallelBuilding = true;

  installPhase = ''
  mkdir -p $out/bin
  cp source/eternity $out/bin
  '';

  meta = {
    homepage = http://doomworld.com/eternity;
    description = "New school Doom port by James Haley";
    license = stdenv.lib.licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [ MP2E ];
  };
}
