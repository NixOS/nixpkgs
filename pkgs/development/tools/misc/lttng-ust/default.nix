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
  version = "2.10.4";

  src = fetchurl {
    url = "https://lttng.org/files/lttng-ust/${pname}-${version}.tar.bz2";
    sha256 = "0rx9q5r9qcdx3i9i0rx28p33yl52sd6f35qj7qs4li2w42xv9mbm";
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
