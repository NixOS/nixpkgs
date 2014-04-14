{ stdenv, fetchurl, pkgconfig, glib, libuuid, popt }:

stdenv.mkDerivation rec {
  name = "babeltrace-1.2.1";

  src = fetchurl {
    url = "http://www.efficios.com/files/babeltrace/${name}.tar.bz2";
    sha256 = "1pwg0y57iy4c8wynb6bj7f6bxaiclmxcm4f3nllpw9brhbdzygc1";
  };

  buildInputs = [ pkgconfig glib libuuid popt ];

  meta = with stdenv.lib; {
    description = "Command-line tool and library to read and convert LTTng tracefiles";
    homepage = http://www.efficios.com/babeltrace;
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };

}
