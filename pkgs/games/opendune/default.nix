{ stdenv, fetchFromGitHub, SDL, SDL_image, SDL_mixer, binutils }:

stdenv.mkDerivation rec {
  name = "opendune-${version}";
  version = "0.9";

  src = fetchFromGitHub {
    owner = "OpenDUNE";
    repo = "OpenDUNE";
    rev = "af3f3239eca1073ac9d621286014fba282c1dc5a";
    sha256 = "15rvrnszdy3db8s0dmb696l4isb3x2cpj7wcl4j09pdi59pc8p37";
  };

  buildInputs = [ SDL SDL_image SDL_mixer ];

  installPhase = ''
    install -m 555 -D bin/opendune $out/bin/opendune
    echo 'set the opendune configuration at ~/.config/opendune/opendune.ini:'
    echo '[opendune]'
    echo 'datadir=/path/to/opendune-data'
    echo 'download dune2 into [datadir] http://www.bestoldgames.net/eng/old-games/dune-2.php'
  '';

  meta = with stdenv.lib; {
    description = "Dune, Reinvented";
    homepage = https://github.com/OpenDUNE/OpenDUNE;
    license = licenses.gpl2;
    maintainers = [ maintainers.nand0p ];
    platforms = platforms.linux;
  };
}
