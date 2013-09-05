{ stdenv, fetchurl, popt, libuuid, liburcu, lttngUst }:

stdenv.mkDerivation rec {
  name = "lttng-tools-2.3.0";

  src = fetchurl {
    url = "https://lttng.org/files/lttng-tools/${name}.tar.bz2";
    sha256 = "16j55xqrh00mjbcvdmdkfxchavi7jsxlpnfjqc1g1d3x65ss9wri";
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
