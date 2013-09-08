{ stdenv, fetchurl, liburcu }:

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
  name = "lttng-ust-2.3.0";

  src = fetchurl {
    url = "https://lttng.org/files/lttng-ust/${name}.tar.bz2";
    sha256 = "1hazjybrppyaakvfp1bs92vx0n2sgcsw0m6i5hwq7xq8vij7cj4q";
  };

  buildInputs = [ liburcu ];

  meta = with stdenv.lib; {
    description = "LTTng Userspace Tracer libraries";
    homepage = http://lttng.org/;
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };

}
