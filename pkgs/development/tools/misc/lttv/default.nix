{ stdenv, fetchurl, pkgconfig, glib, gtk2, popt, babeltrace }:

stdenv.mkDerivation rec {
  name = "lttv-1.5-beta1";

  src = fetchurl {
    url = "http://lttng.org/files/packages/${name}.tar.bz2";
    sha256 = "0cz69q189wndwpvic0l6wvzl1nsfqadbrigaaxgzij72r7n89sfc";
  };

  buildInputs = [ pkgconfig glib gtk2 popt babeltrace ];

  meta = with stdenv.lib; {
    description = "Graphical trace viewer for LTTng trace files";
    homepage = http://lttng.org/;
    # liblttvtraceread (ltt/ directory) is distributed under the GNU LGPL v2.1.
    # The rest of the LTTV package is distributed under the GNU GPL v2.
    license = with licenses; [ gpl2 lgpl21 ];
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };

}
