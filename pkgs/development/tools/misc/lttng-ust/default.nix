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
  version = "2.10.3";

  src = fetchurl {
    url = "https://lttng.org/files/lttng-ust/${name}.tar.bz2";
    sha256 = "0aw580xx6x9hgbxrzil7yqv12j8yvi5d9iibldx3z5jz1pwj114y";
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
