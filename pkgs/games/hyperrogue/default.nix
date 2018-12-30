{ stdenv, fetchFromGitHub, SDL, SDL_ttf, SDL_gfx, SDL_mixer, autoreconfHook,
  libpng, glew }:

stdenv.mkDerivation rec {
  name = "hyperrogue-${version}";
  version = "10.5a";

  src = fetchFromGitHub {
    owner = "zenorogue";
    repo = "hyperrogue";
    rev = "v${version}";
    sha256 = "1s5jm5qrbw60s8q73fzjk9g2fmapd0i7zmrna2dqx55i1gg9d597";
  };

  CPPFLAGS = "-I${SDL.dev}/include/SDL";

  buildInputs = [ autoreconfHook SDL SDL_ttf SDL_gfx SDL_mixer libpng glew ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://www.roguetemple.com/z/hyper/;
    description = "A roguelike game set in hyperbolic geometry";
    maintainers = with maintainers; [ rardiol ];
    license = licenses.gpl2;
    platforms = platforms.all;
  };
}
