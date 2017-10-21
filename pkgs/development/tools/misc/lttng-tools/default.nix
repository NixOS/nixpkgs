{ stdenv, fetchurl, pkgconfig, popt, libuuid, liburcu, lttng-ust, kmod, libxml2 }:

stdenv.mkDerivation rec {
  name = "lttng-tools-${version}";
  version = "2.10.1";

  src = fetchurl {
    url = "https://lttng.org/files/lttng-tools/${name}.tar.bz2";
    sha256 = "005axllajfbxh73vh1cacbapdvbxjsi3pkzq40giih4ps9x4pg10";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ popt libuuid liburcu lttng-ust libxml2 kmod ];

  meta = with stdenv.lib; {
    description = "Tracing tools (kernel + user space) for Linux";
    homepage = http://lttng.org/;
    license = licenses.lgpl21;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };

}
