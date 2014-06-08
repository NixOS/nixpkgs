{ stdenv, fetchurl, ncurses }:

stdenv.mkDerivation rec {
  name = "dvtm-0.11";

  meta = {
    description = "Dynamic virtual terminal manager";
    homepage = "http://www.brain-dump.org/projects/dvtm";
    license = stdenv.lib.licenses.mit;
    platfroms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ iyzsong ];
  };

  src = fetchurl {
    url = "${meta.homepage}/${name}.tar.gz";
    sha256 = "11zb5wnvmcx8np2886hwaqijvhdw8l87lldxhgqikw2ncpgrz8h1";
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
