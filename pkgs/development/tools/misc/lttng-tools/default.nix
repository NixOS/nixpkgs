{ stdenv, fetchurl, pkgconfig, popt, libuuid, liburcu, lttng-ust, kmod, libxml2 }:

stdenv.mkDerivation rec {
  pname = "lttng-tools";
  version = "2.10.7";

  src = fetchurl {
    url = "https://lttng.org/files/lttng-tools/${pname}-${version}.tar.bz2";
    sha256 = "04hkga0hnyjmv42mxj3njaykqmq9x4abd5qfyds5r62x1khfnwgd";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ popt libuuid liburcu lttng-ust libxml2 kmod ];

  meta = with stdenv.lib; {
    description = "Tracing tools (kernel + user space) for Linux";
    homepage = https://lttng.org/;
    license = licenses.lgpl21;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };

}
