{ stdenv, fetchurl, pkgconfig, glib, libuuid, popt }:

stdenv.mkDerivation rec {
  name = "babeltrace-1.2.4";

  src = fetchurl {
    url = "http://www.efficios.com/files/babeltrace/${name}.tar.bz2";
    sha256 = "1ccy432srwz4xzi6pswfkjsymw00g1p0aqwr0l1mfzfws8d3lvk6";
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
