{ stdenv, fetchurl, pkgconfig, glib, libuuid, popt, elfutils }:

stdenv.mkDerivation rec {
  name = "babeltrace-1.5.7";

  src = fetchurl {
    url = "https://www.efficios.com/files/babeltrace/${name}.tar.bz2";
    sha256 = "0yw05cnk5w8b5nbznycglyn4h3hq56a1n8rlb9k9rlzz4ph32lr1";
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
