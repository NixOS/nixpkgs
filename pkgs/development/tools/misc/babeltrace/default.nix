{ stdenv, fetchurl, pkgconfig, glib, libuuid, popt, elfutils }:

stdenv.mkDerivation rec {
  name = "babeltrace-1.5.5";

  src = fetchurl {
    url = "http://www.efficios.com/files/babeltrace/${name}.tar.bz2";
    sha256 = "1b78fam1gbsalga5pppn8ka461q35a9svz3mlbv82ssakdw4d4a0";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ glib libuuid popt elfutils ];

  meta = with stdenv.lib; {
    description = "Command-line tool and library to read and convert LTTng tracefiles";
    homepage = https://www.efficios.com/babeltrace;
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };

}
