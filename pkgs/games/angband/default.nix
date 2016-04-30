{stdenv, fetchFromGitHub, autoconf, automake, ncurses }:

stdenv.mkDerivation rec {
  version = "4.0.5";
  name = "angband-${version}";
  src = fetchFromGitHub {
    owner = "angband";
    repo = "angband";
    rev = version;
    sha256 = "1l7ybqmsxpsijm7iqiqjpa7lhjafxml743q4crxn8wnwrbjzbi86";
      };
  buildInputs = [ autoconf automake ncurses ];
  configurePhase = ''
    ./autogen.sh
    ./configure --prefix=$out --bindir=$out/bin --disable-x11
  '';
  meta = {
    homepage = "http://rephial.org/";
    description = "Angband (classic rogue-like game)";
    maintainers = [ stdenv.lib.maintainers.chattered  ];
    license = stdenv.lib.licenses.gpl2;
  };
}
