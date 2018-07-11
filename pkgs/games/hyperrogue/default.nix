{ stdenv, fetchFromGitHub, SDL, SDL_ttf, SDL_gfx, SDL_mixer, autoreconfHook,
  libpng, glew }:

stdenv.mkDerivation rec {
  name = "hyperrogue-${version}";
  version = "10.4j";

  src = fetchFromGitHub {
    owner = "zenorogue";
    repo = "hyperrogue";
    rev = "v${version}";
    sha256 = "0p0aplfr5hs5dmkgbd4rhvrdk33gss1wdb7knd2vf27n4c2avjcl";
  };

  CPPFLAGS = "-I${SDL.dev}/include/SDL";

  buildInputs = [ autoreconfHook SDL SDL_ttf SDL_gfx SDL_mixer libpng glew ];

  meta = with stdenv.lib; {
    homepage = http://www.roguetemple.com/z/hyper/;
    description = "A roguelike game set in hyperbolic geometry";
    maintainers = with maintainers; [ rardiol ];
    license = licenses.gpl2;
    platforms = platforms.all;
  };
}
