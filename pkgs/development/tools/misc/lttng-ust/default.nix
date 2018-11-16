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
  version = "2.10.2";

  src = fetchurl {
    url = "https://lttng.org/files/lttng-ust/${name}.tar.bz2";
    sha256 = "0if0hrs32r98sp85c8c63zpgy5xjw6cx8wrs65xq227b0jwj5jn4";
  };

  buildInputs = [ python ];

  preConfigure = ''
    patchShebangs .
  '';
  
  propagatedBuildInputs = [ liburcu ];

  meta = with stdenv.lib; {
    description = "LTTng Userspace Tracer libraries";
    homepage = https://lttng.org/;
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };

}
