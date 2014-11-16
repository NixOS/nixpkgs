{ stdenv, fetchurl, popt, libuuid, liburcu, lttng-ust, kmod, libxml2 }:

stdenv.mkDerivation rec {
  name = "lttng-tools-2.5.0";

  src = fetchurl {
    url = "https://lttng.org/files/lttng-tools/${name}.tar.bz2";
    sha256 = "19qw3v8z5kz9ls988sc1d8yczl9i1d5c6vmzna8wz790szwvin6s";
  };

  buildInputs = [ popt libuuid liburcu lttng-ust libxml2 ];

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
