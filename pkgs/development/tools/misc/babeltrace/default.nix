{ stdenv, fetchurl, pkgconfig, glib, libuuid, popt }:

stdenv.mkDerivation rec {
  name = "babeltrace-1.1.1";

  src = fetchurl {
    url = "http://www.efficios.com/files/babeltrace/${name}.tar.bz2";
    sha256 = "04jc1yd3aaq59fmpzswzc78cywpq7wzjfqdlsg7xc76ivb8cggfz";
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
