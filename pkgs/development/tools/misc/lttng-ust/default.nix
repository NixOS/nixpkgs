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
  name = "lttng-ust-2.5.1";

  src = fetchurl {
    url = "https://lttng.org/files/lttng-ust/${name}.tar.bz2";
    sha256 = "0ij5p2j8q63zqnj3i3hgymgib717r2bq07ymy5cwdra1hvby5ngv";
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
