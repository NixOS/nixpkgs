{ stdenv, fetchurl, pkgs }:

stdenv.mkDerivation rec {
  name = "pipes-${version}";
  version = "1.2.0";

  src = fetchurl {
    url = "https://github.com/pipeseroni/pipes.sh/archive/v${version}.tar.gz";
    sha256 = "1v0xhgq30zkfjk9l5g8swpivh7rxfjbzhbjpr2c5c836wgn026fb";
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
