{ stdenv, fetchFromGitHub, ncurses }:

stdenv.mkDerivation rec {
  name = "tty-clock-${version}";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "xorg62";
    repo = "tty-clock";
    rev = "v0.1";
    sha256 = "14h70ky5y9nb3mzhlshdgq5n47hg3g6msnwbqd7nnmjzrw1nmarl";
  };

  buildInputs = [ ncurses ];

  preInstall = ''
    sed -i 's@/usr/local/@$(out)/@' Makefile
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/xorg62/tty-clock;
    license = licenses.free;
    description = "Digital clock in ncurses";
    platforms = platforms.all;
    maintainers = [ maintainers.koral ];
  };
}
