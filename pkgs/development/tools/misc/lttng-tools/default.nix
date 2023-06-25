{ lib, stdenv, fetchurl, pkg-config, popt, libuuid, liburcu, lttng-ust, kmod, libxml2 }:

stdenv.mkDerivation rec {
  pname = "lttng-tools";
  version = "2.13.10";

  src = fetchurl {
    url = "https://lttng.org/files/lttng-tools/${pname}-${version}.tar.bz2";
    sha256 = "sha256-5dEJXsEyJWXzjxSTRvcZZ0lsKB6sxR7Fx3mUuFDn0zU=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ popt libuuid liburcu lttng-ust libxml2 kmod ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Tracing tools (kernel + user space) for Linux";
    homepage = "https://lttng.org/";
    license = with licenses; [ lgpl21Only gpl2Only ];
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };

}
