{ stdenv, fetchurl, ncurses }:

stdenv.mkDerivation rec {
  name = "dvtm-0.10";

  meta = {
    description = "Dynamic virtual terminal manager";
    homepage = "http://www.brain-dump.org/projects/dvtm";
    license = stdenv.lib.licenses.mit;
    platfroms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ iyzsong ];
  };

  src = fetchurl {
    url = "${meta.homepage}/${name}.tar.gz";
    sha256 = "0lb6p06jfaz1z07k0v2gipzx67swf7rijz17g5ndhng2g0jqfl3p";
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
