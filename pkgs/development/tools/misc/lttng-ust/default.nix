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
  name = "lttng-ust-${version}";
  version = "2.9.0";

  src = fetchurl {
    url = "https://lttng.org/files/lttng-ust/${name}.tar.bz2";
    sha256 = "1bsxxaqhkh9bwr1ll5acb41hvis2lhkl00h5ra2wdps27y31lm2d";
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
