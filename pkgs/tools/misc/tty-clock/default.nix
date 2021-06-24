{ lib, stdenv, fetchFromGitHub, ncurses, pkg-config }:

stdenv.mkDerivation rec {
  pname = "tty-clock";
  version = "2.3";

  src = fetchFromGitHub {
    owner = "xorg62";
    repo = "tty-clock";
    rev = "v${version}";
    sha256 = "16v3pmva13skpfjja96zacjpxrwzs1nb1iqmrp2qzvdbcm9061pp";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ ncurses ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    homepage = "https://github.com/xorg62/tty-clock";
    license = licenses.free;
    description = "Digital clock in ncurses";
    platforms = platforms.all;
    maintainers = [ maintainers.koral ];
  };
}
