{ stdenv, fetchFromGitHub, ncurses, pkgconfig }:

stdenv.mkDerivation rec {
  name = "tty-clock-${version}";
  version = "2.3";

  src = fetchFromGitHub {
    owner = "xorg62";
    repo = "tty-clock";
    rev = "v${version}";
    sha256 = "16v3pmva13skpfjja96zacjpxrwzs1nb1iqmrp2qzvdbcm9061pp";
  };
  
  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ ncurses ];

  makeFlags = "PREFIX=$(out)";

  meta = with stdenv.lib; {
    homepage = https://github.com/xorg62/tty-clock;
    license = licenses.free;
    description = "Digital clock in ncurses";
    platforms = platforms.all;
    maintainers = [ maintainers.koral ];
  };
}
