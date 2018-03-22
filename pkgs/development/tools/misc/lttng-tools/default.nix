{ stdenv, fetchurl, pkgconfig, popt, libuuid, liburcu, lttng-ust, kmod, libxml2 }:

stdenv.mkDerivation rec {
  name = "lttng-tools-${version}";
  version = "2.10.2";

  src = fetchurl {
    url = "https://lttng.org/files/lttng-tools/${name}.tar.bz2";
    sha256 = "17wsdhkw8c8gb0d1bcgw4dfx2ljrq4rzgpi8sb9y9hs6pbwqy0xk";
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
