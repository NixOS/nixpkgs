{ stdenv, fetchFromGitHub, ncurses, boost }:

stdenv.mkDerivation rec {
  name = "bastet-${version}";
  version = "0.43.1";
  buildInputs = [ ncurses boost ];

  src = fetchFromGitHub {
    owner = "fph";
    repo = "bastet";
    rev = version;
    sha256 = "14ymdarx30zqxyixvb17h4hs57y6zfx0lrdvc200crllz8zzdx5z";
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
