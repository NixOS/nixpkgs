{ stdenv, fetchurl, popt, libuuid, liburcu, lttngUst }:

stdenv.mkDerivation rec {
  name = "lttng-tools-2.2.3";

  src = fetchurl {
    url = "https://lttng.org/files/lttng-tools/${name}.tar.bz2";
    sha256 = "1p16n42j34xkaj17zg2g12rzkfwpdv9ay1h4bkdq6038v320mljv";
  };

  buildInputs = [ popt libuuid liburcu lttngUst ];

  patches = [ ./lttng-change-modprobe-path-from-sbin-modprobe-to-modprobe.patch ];

  meta = with stdenv.lib; {
    description = "Tracing tools (kernel + user space) for Linux";
    homepage = http://lttng.org/;
    license = licenses.lgpl21;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };

}
