{ stdenv, fetchFromGitHub, ncurses }:
stdenv.mkDerivation rec {
  name = "ttyplot-${version}";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "tenox7";
    repo = "ttyplot";
    rev = version;
    sha256 = "1i54hw7fad42gdlrlqg7s0vhsq01yxzdi2s0r3svwbb1sr7ynzn1";
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
    description = "a simple general purpose plotting utility for tty with data input from stdin.";
    homepage = https://github.com/tenox7/ttyplot;
    license = licenses.unlicense;
    maintainers = with maintainers; [ lassulus ];
  };
}
