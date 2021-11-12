{ lib, stdenv, fetchurl, pkg-config, liburcu, numactl, python3 }:

# NOTE:
#   ./configure ...
#   [...]
#   LTTng-UST will be built with the following options:
#
#   Java support (JNI): Disabled
#   sdt.h integration:  Disabled
#   [...]
#
# Debian builds with std.h (systemtap).

stdenv.mkDerivation rec {
  pname = "lttng-ust";
  version = "2.13.0";

  src = fetchurl {
    url = "https://lttng.org/files/lttng-ust/${pname}-${version}.tar.bz2";
    sha256 = "0l0p6y2zrd9hgd015dhafjmpcj7waz762n6wf5ws1xlwcwrwkr2l";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ numactl python3 ];

  preConfigure = ''
    patchShebangs .
  '';

  propagatedBuildInputs = [ liburcu ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "LTTng Userspace Tracer libraries";
    homepage = "https://lttng.org/";
    license = with licenses; [ lgpl21Only gpl2Only mit ];
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };

}
