{ stdenv, fetchFromGitHub, SDL, SDL_ttf, SDL_gfx, SDL_mixer, autoreconfHook,
  libpng, glew }:

stdenv.mkDerivation rec {
  name = "hyperrogue-${version}";
  version = "10.5e";

  src = fetchFromGitHub {
    owner = "zenorogue";
    repo = "hyperrogue";
    rev = "v${version}";
    sha256 = "1sjr26if3xv8xv52app1hkxs0bbgbviagydm4mdwbxjpd6v3d1aa";
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
