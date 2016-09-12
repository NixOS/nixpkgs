{ stdenv, fetchurl, popt, libuuid, liburcu, lttng-ust, kmod, libxml2 }:

stdenv.mkDerivation rec {
  name = "lttng-tools-2.5.2";

  src = fetchurl {
    url = "https://lttng.org/files/lttng-tools/${name}.tar.bz2";
    sha256 = "0g931f90pl9bfgsxihrj0zlw9ivyaplbiw28axkscmjvzd1d6lhz";
  };

  buildInputs = [ popt libuuid liburcu lttng-ust libxml2 ];

  prePatch = ''
    sed -e "s|/sbin/modprobe|${kmod}/bin/modprobe|g" \
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
