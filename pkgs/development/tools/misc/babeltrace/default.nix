{ stdenv, fetchurl, pkgconfig, glib, libuuid, popt, elfutils }:

stdenv.mkDerivation rec {
  name = "babeltrace-1.5.4";

  src = fetchurl {
    url = "http://www.efficios.com/files/babeltrace/${name}.tar.bz2";
    sha256 = "1h8zi7afilbfx4jvdlhhgysj6x01w3799mdk4mdcgax04fch6hwn";
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
