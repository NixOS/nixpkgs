{ lib, stdenv, fetchurl, makeWrapper, coreutils, ncurses }:

stdenv.mkDerivation rec {
  pname = "pipes";
  version = "1.3.0";

  src = fetchurl {
    url = "https://github.com/pipeseroni/pipes.sh/archive/v${version}.tar.gz";
    sha256 = "09m4alb3clp3rhnqga5v6070p7n1gmnwp2ssqhq87nf2ipfpcaak";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir $out -p
    make PREFIX=$out/ install

    wrapProgram $out/bin/pipes.sh \
      --set PATH "${lib.makeBinPath [ coreutils ncurses ]}"
  '';

  meta = with lib; {
    homepage = "https://github.com/pipeseroni/pipes.sh";
    description = "Animated pipes terminal screensaver";
    license = licenses.mit;
    maintainers = [ maintainers.matthiasbeyer ];
    platforms = platforms.unix;
  };
}
