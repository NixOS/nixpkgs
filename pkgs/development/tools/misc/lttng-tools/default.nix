{ stdenv, fetchurl, pkgconfig, popt, libuuid, liburcu, lttng-ust, kmod, libxml2 }:

stdenv.mkDerivation rec {
  pname = "lttng-tools";
  version = "2.11.0";

  src = fetchurl {
    url = "https://lttng.org/files/lttng-tools/${pname}-${version}.tar.bz2";
    sha256 = "1g0g7ypxvc7wd5x4d4ixmfgl9yk0lxax3ymm95hcjwxn5p497r6w";
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
