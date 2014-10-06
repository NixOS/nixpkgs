{ stdenv, fetchurl, pkgconfig, glib, libuuid, popt }:

stdenv.mkDerivation rec {
  name = "babeltrace-1.2.3";

  src = fetchurl {
    url = "http://www.efficios.com/files/babeltrace/${name}.tar.bz2";
    sha256 = "1b47d4i4f3gjb37m62k6hq0jlag4qkmblx6lcjf4s902h6bscvvr";
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
