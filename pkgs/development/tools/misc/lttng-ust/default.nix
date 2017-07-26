{ stdenv, fetchurl, liburcu, python }:

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
  version = "2.9.1";

  src = fetchurl {
    url = "https://lttng.org/files/lttng-ust/${name}.tar.bz2";
    sha256 = "196snxrs1p205jz566rwxh7dqzsa3k16c7vm6k7i3gdvrmkx54dq";
  };

  buildInputs = [ liburcu python ];

  preConfigure = ''
    patchShebangs .
  '';

  meta = with stdenv.lib; {
    description = "LTTng Userspace Tracer libraries";
    homepage = http://lttng.org/;
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };

}
