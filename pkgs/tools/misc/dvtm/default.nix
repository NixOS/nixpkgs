{ stdenv, fetchurl, ncurses }:

stdenv.mkDerivation rec {
  name = "dvtm-0.13";

  meta = {
    description = "Dynamic virtual terminal manager";
    homepage = http://www.brain-dump.org/projects/dvtm;
    license = stdenv.lib.licenses.mit;
    platfroms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ iyzsong ];
  };

  src = fetchurl {
    url = "${meta.homepage}/${name}.tar.gz";
    sha256 = "0s15i3ilrfh069m3qimam25w56flmm65c34ima5y3f50kmyblpaj";
  };

  buildInputs = [ ncurses ];

  prePatch = ''
    substituteInPlace Makefile \
      --replace /usr/share/terminfo $out/share/terminfo
  '';

  installPhase = ''
    make PREFIX=$out install
  '';
}
