{ stdenv, fetchurl, ncurses, libpcap }:

stdenv.mkDerivation rec {
  name = "tcptrack-${version}";
  version = "1.4.2";

  src = fetchurl {
    # TODO: find better URL
    url = http://pkgs.fedoraproject.org/repo/pkgs/tcptrack/tcptrack-1.4.2.tar.gz/dacf71a6b5310caf1203a2171b598610/tcptrack-1.4.2.tar.gz;
    sha256 = "0jbh20kjaqdiasy5s9dk53dv4vpnbh31kqcmhwz9vi3qqzhv21v6";
  };

  buildInputs = [ ncurses libpcap ];

  NIX_CFLAGS_COMPILE = "-Wno-error=cpp";

  meta = with stdenv.lib; {
    description = "libpcap based program for live TCP connection monitoring";
    homepage = http://www.rhythm.cx/~steve/devel/tcptrack/; # dead link
    license = licenses.lgpl21;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
