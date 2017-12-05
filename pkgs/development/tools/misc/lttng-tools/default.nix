{ stdenv, fetchurl, pkgconfig, popt, libuuid, liburcu, lttng-ust, kmod, libxml2 }:

stdenv.mkDerivation rec {
  name = "lttng-tools-${version}";
  version = "2.9.5";

  src = fetchurl {
    url = "https://lttng.org/files/lttng-tools/${name}.tar.bz2";
    sha256 = "073kzfiwgvz7c10hihjwn1p53hh1jwvdkkway0jj2rbczjv9x0vp";
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
