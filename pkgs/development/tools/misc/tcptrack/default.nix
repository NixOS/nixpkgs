{ stdenv, fetchFromGitHub, ncurses, libpcap }:

stdenv.mkDerivation rec {
  name = "tcptrack-${version}";
  version = "1.4.3";

  src = fetchFromGitHub {
    owner = "bchretien";
    repo = "tcptrack";
    rev = "d05fe08154ff1e46578e92be49e4cfa2c6543283";
    sha256 = "08lh3l67wn4kq9q0nfspc7rj0jvp9dzwjgxpvqliwcif8cy5mi45";
  };

  buildInputs = [ ncurses libpcap ];

  NIX_CFLAGS_COMPILE = "-Wno-error=cpp";

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "libpcap based program for live TCP connection monitoring";
    license = licenses.lgpl21;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor maintainers.vrthra ];
  };
}
