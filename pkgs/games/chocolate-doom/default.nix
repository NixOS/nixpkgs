{ stdenv, autoreconfHook, pkgconfig, SDL2, SDL2_mixer, SDL2_net, fetchFromGitHub, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "chocolate-doom";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "chocolate-doom";
    repo = pname;
    rev = "${pname}-${version}";
    sha256 = "0ajzb767wyj8vzhjpsmgslw42b0155ji4alk26shxl7k5ijbzn0j";
  };

  patches = [
    # Fixes CVE-2020-14983
    ( fetchpatch {
      url = "https://github.com/chocolate-doom/chocolate-doom/commit/f1a8d991aa8a14afcb605cf2f65cd15fda204c56.diff";
      sha256 = "1zj8mh25dnln81rnwag7xp3wc10i8qx0pvg9v2li8gqczlkb91bi";
    } )
    ( fetchpatch {
      url = "https://github.com/chocolate-doom/chocolate-doom/commit/54fb12eeaa7d527defbe65e7e00e37d5feb7c597.diff";
      sha256 = "0hl7qjll2ys53q62pmc6mj7bvyz0qjlyddz2lc8l1sm4rcf7abns";
    } )
  ];

  postPatch = ''
    sed -e 's#/games#/bin#g' -i src{,/setup}/Makefile.am
  '';

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ SDL2 SDL2_mixer SDL2_net ];

  enableParallelBuilding = true;

  meta = {
    homepage = "http://chocolate-doom.org/";
    description = "A Doom source port that accurately reproduces the experience of Doom as it was played in the 1990s";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.unix;
    hydraPlatforms = stdenv.lib.platforms.linux; # darwin times out
    maintainers = with stdenv.lib.maintainers; [ MP2E ];
  };
}
