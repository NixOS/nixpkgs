{ stdenv, cmake, mesa, SDL, SDL_mixer, SDL_net, fetchurl }:

stdenv.mkDerivation rec {
  name = "eternity-engine-3.40.46";
  src = fetchurl {
    url = https://github.com/team-eternity/eternity/archive/3.40.46.tar.gz;
    sha256 = "0jq8q0agw7lgab9q2h8wcaakvg913l9j3a6ss0hn9661plkw2yb4";
  };

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
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ MP2E ];
  };
}
