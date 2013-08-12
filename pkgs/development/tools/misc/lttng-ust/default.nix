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
  name = "lttng-ust-2.2.1";

  src = fetchurl {
    url = "https://lttng.org/files/lttng-ust/${name}.tar.bz2";
    sha256 = "0881ri3v96fjii24qnwgsypk4crri4qp6mc4zp7kwghz8gys9rla";
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
