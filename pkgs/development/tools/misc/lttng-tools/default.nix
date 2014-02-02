{ stdenv, fetchurl, popt, libuuid, liburcu, lttngUst, kmod }:

stdenv.mkDerivation rec {
  name = "lttng-tools-2.3.0";

  src = fetchurl {
    url = "https://lttng.org/files/lttng-tools/${name}.tar.bz2";
    sha256 = "16j55xqrh00mjbcvdmdkfxchavi7jsxlpnfjqc1g1d3x65ss9wri";
  };

  buildInputs = [ popt libuuid liburcu lttngUst ];

  prePatch = ''
    sed -e "s|/sbin/modprobe|${kmod}/sbin/modprobe|g" \
        -i src/bin/lttng-sessiond/modprobe.c
  '';

  meta = with stdenv.lib; {
    description = "Tracing tools (kernel + user space) for Linux";
    homepage = http://lttng.org/;
    license = licenses.lgpl21;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };

}
