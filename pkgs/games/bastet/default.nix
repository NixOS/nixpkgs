{ stdenv, fetchFromGitHub, ncurses, boost }:

stdenv.mkDerivation rec {
  name = "bastet-${version}";
  version = "0.43.2";
  buildInputs = [ ncurses boost ];

  src = fetchFromGitHub {
    owner = "fph";
    repo = "bastet";
    rev = version;
    sha256 = "09kamxapm9jw9przpsgjfg33n9k94bccv65w95dakj0br33a75wn";
  };

  installPhase = ''
    mkdir -p "$out"/bin
    cp bastet "$out"/bin/
    mkdir -p "$out"/share/man/man6
    cp bastet.6 "$out"/share/man/man6
  '';

  meta = with stdenv.lib; {
    description = "Tetris clone with 'bastard' block-choosing AI";
    homepage = http://fph.altervista.org/prog/bastet.html;
    license = licenses.gpl3;
    maintainers = [ maintainers.dezgeg ];
    platforms = platforms.linux;
  };
}
