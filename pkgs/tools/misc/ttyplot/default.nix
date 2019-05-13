{ stdenv, fetchFromGitHub, ncurses }:

stdenv.mkDerivation rec {
  name = "ttyplot-${version}";
  version = "1.4";

  src = fetchFromGitHub {
    owner = "tenox7";
    repo = "ttyplot";
    rev = version;
    sha256 = "19qm0hx9ljdw9qg78lydn3c627xy7xnx3knq5f7caw9lf0cdp7kf";
  };

  buildInputs = [ ncurses ];

  buildPhase = ''
   ${stdenv.cc}/bin/cc ./ttyplot.c -lncurses -o ttyplot
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp ttyplot $out/bin/
  '';

  meta = with stdenv.lib; {
    description = "A simple general purpose plotting utility for tty with data input from stdin";
    homepage = https://github.com/tenox7/ttyplot;
    license = licenses.unlicense;
    maintainers = with maintainers; [ lassulus ];
  };
}
