{ stdenv, fetchurl, ncurses }:

stdenv.mkDerivation rec {
  name = "dvtm-0.14";

  meta = {
    description = "Dynamic virtual terminal manager";
    homepage = http://www.brain-dump.org/projects/dvtm;
    license = stdenv.lib.licenses.mit;
    platfroms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ iyzsong ];
  };

  src = fetchurl {
    url = "${meta.homepage}/${name}.tar.gz";
    sha256 = "0ykl8dz7ivjgdzhmhlgidnp2ffh5gxq9lbg276w7iid4z10v76wa";
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
