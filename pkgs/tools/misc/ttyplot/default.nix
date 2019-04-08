{ stdenv, fetchFromGitHub, ncurses }:

stdenv.mkDerivation rec {
  name = "ttyplot-${version}";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "tenox7";
    repo = "ttyplot";
    rev = version;
    sha256 = "1xaqzm71w2n0q532wpa3w818mvjvch3h34m2aq7pldkyk09frjxh";
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
