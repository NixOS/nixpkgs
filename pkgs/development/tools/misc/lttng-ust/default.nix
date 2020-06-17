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
  pname = "lttng-ust";
  version = "2.10.5";

  src = fetchurl {
    url = "https://lttng.org/files/lttng-ust/${pname}-${version}.tar.bz2";
    sha256 = "0ddwk0nl28bkv2xb78gz16a2bvlpfbjmzwfbgwf5p1cq46dyvy86";
  };

  buildInputs = [ python ];

  preConfigure = ''
    patchShebangs .
  '';
  
  propagatedBuildInputs = [ liburcu ];

  meta = with stdenv.lib; {
    description = "LTTng Userspace Tracer libraries";
    homepage = "https://lttng.org/";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };

}
