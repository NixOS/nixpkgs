{ stdenv, fetchurl, pkgs }:

stdenv.mkDerivation rec {
  name = "pipes-${version}";
  version = "1.16.1";

  src = fetchurl {
    url = "http://bisqwit.iki.fi/src/arch/${name}.tar.bz2";
    sha256 = "0b56mls2ygg66p1b66ldws5x0a0k3vk4rmyhlis13s8fw7vh5fyp";
  };

  buildInputs = with pkgs; [ bash ];

  installPhase = ''
    mkdir $out -p
    make PREFIX=$out/ install
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/pipeseroni/pipes.sh;
    description = "Animated pipes terminal screensaver";
    license = licenses.mit;
    maintainers = [ maintainers.matthiasbeyer ];
    platforms = platforms.unix;
  };
}
