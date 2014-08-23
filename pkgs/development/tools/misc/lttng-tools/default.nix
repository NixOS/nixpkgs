{ stdenv, fetchurl, popt, libuuid, liburcu, lttng-ust, kmod }:

stdenv.mkDerivation rec {
  name = "lttng-tools-2.4.1";

  src = fetchurl {
    url = "https://lttng.org/files/lttng-tools/${name}.tar.bz2";
    sha256 = "1v9f7a3c2shwgn4g759bblgr27h9ql9sfq71r1mbkf8rd235g2jr";
  };

  buildInputs = [ popt libuuid liburcu lttng-ust ];

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
