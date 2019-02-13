{ stdenv, fetchFromGitHub, ncurses }:

stdenv.mkDerivation rec {
  name = "ttyplot-${version}";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "tenox7";
    repo = "ttyplot";
    rev = version;
    sha256 = "0icv40fmf8z3a00csjh4c4svq3y6s6j70jgxjd6zqlxyks9wj7mr";
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
