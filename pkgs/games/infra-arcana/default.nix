{ stdenv, fetchFromGitLab, cmake, SDL2, SDL2_image, SDL2_mixer }:

stdenv.mkDerivation {
	name = "infra-arcana";
	builder = ./build.sh;
	src = fetchFromGitLab {
		owner = "martin-tornqvist";
		repo = "ia";
		rev = "e50a5ff4";
		sha256 = "0fgz6y0fahy7nrwip6k6392msvq5z1zbbrsrzrqam324rcb7rsmb";
	};
	patches = [ ./sdl2find.patch ];
	inherit cmake;
	inherit SDL2;
	SDL2DEV = SDL2.dev;
	inherit SDL2_image;
	inherit SDL2_mixer;
	meta = with stdenv.lib; {
		homepage = "https://sites.google.com/site/infraarcana/";
		description = "A Roguelike inspired by the horror fiction of writer H.P. Lovecraft";
		longDescription = ''Infra Arcana is a Roguelike set in the early 20th century. The goal is to explore the lair of a dreaded cult 		called The Church of Starry Wisdom. Buried deep beneath their hallowed grounds lies an artifact called The Shining Trapezohedron - a window to all secrets of the universe. Your ultimate goal is to unearth this artifact.

			The theme and inspiration for this game comes mainly from the horror fiction writer H.P. Lovecraft. The game also draws flavor from various B-horror movies, as well as the first-person shooter PC game Blood.

			Infra Arcana adheres to the virtues of the Roguelike genre - high replay value and challenging tactical gameplay.
		'';
		license = licenses.agpl3Plus;
		platforms = platforms.linux;
	};
}
