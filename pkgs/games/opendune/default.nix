{ stdenv, fetchFromGitHub, SDL, SDL_image, SDL_mixer }:

# - set the opendune configuration at ~/.config/opendune/opendune.ini:
#     [opendune]
#     datadir=/path/to/opendune-data
# - download dune2 into [datadir] http://www.bestoldgames.net/eng/old-games/dune-2.php

stdenv.mkDerivation rec {
  name = "opendune-${version}";
  version = "0.9";

  src = fetchFromGitHub {
    owner = "OpenDUNE";
    repo = "OpenDUNE";
    rev = version;
    sha256 = "15rvrnszdy3db8s0dmb696l4isb3x2cpj7wcl4j09pdi59pc8p37";
  };

  buildInputs = [ SDL SDL_image SDL_mixer ];

  installPhase = ''
    install -m 555 -D bin/opendune $out/bin/opendune
  '';

  meta = with stdenv.lib; {
    description = "Dune, Reinvented";
    homepage = https://github.com/OpenDUNE/OpenDUNE;
    license = licenses.gpl2;
    maintainers = [ maintainers.nand0p ];
    platforms = platforms.linux;
  };
}
