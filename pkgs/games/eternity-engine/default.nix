{ stdenv, cmake, mesa_noglu, SDL, SDL_mixer, SDL_net, fetchFromGitHub, makeWrapper }:

stdenv.mkDerivation rec {
  name = "eternity-engine-${version}";
  version = "3.42.02";
  src = fetchFromGitHub {
    owner = "team-eternity";
    repo = "eternity";
    rev = "${version}";
    sha256 = "00kpq4k23hjmzjaymw3sdda7mqk8fjq6dzf7fmdal9fm7lfmj41k";
  };

  nativeBuildInputs = [ cmake makeWrapper ];
  buildInputs = [ mesa_noglu SDL SDL_mixer SDL_net ];

  enableParallelBuilding = true;

  installPhase = ''
    install -Dm755 source/eternity $out/lib/eternity/eternity
    cp -r $src/base $out/lib/eternity/base
    mkdir $out/bin
    makeWrapper $out/lib/eternity/eternity $out/bin/eternity
  '';

  meta = {
    homepage = http://doomworld.com/eternity;
    description = "New school Doom port by James Haley";
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ MP2E ];
  };
}
