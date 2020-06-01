{ stdenv, autoreconfHook, pkgconfig, SDL2, SDL2_mixer, SDL2_net, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "chocolate-doom";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "chocolate-doom";
    repo = pname;
    rev = "${pname}-${version}";
    sha256 = "0ajzb767wyj8vzhjpsmgslw42b0155ji4alk26shxl7k5ijbzn0j";
  };

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
