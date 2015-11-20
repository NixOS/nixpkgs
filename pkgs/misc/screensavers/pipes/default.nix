{ stdenv, fetchurl, pkgs }:

stdenv.mkDerivation rec {
  name = "pipes-${version}";
  version = "1.1.0";

  src = fetchurl {
    url = "https://github.com/pipeseroni/pipes.sh/archive/v${version}.tar.gz";
    sha256 = "1225llbm0zfnkqykfi7qz7z5p102pwldmj22761m653jy0ahi7w2";
  };

  buildInputs = with pkgs; [ bash ];

  installPhase = ''
    mkdir $out -p
    make PREFIX=$out/ install
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/pipeseroni/pipes.sh";
    description = "Animated pipes terminal screensaver";
    license = licenses.mit;
    maintainers = [ maintainers.matthiasbeyer ];
    platforms = platforms.unix;
  };
}
