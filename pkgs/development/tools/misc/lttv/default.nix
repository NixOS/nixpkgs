{ stdenv, fetchurl, pkgconfig, glib, gtk2, popt, babeltrace }:

stdenv.mkDerivation rec {
  name = "lttv-1.5";

  src = fetchurl {
    url = "http://lttng.org/files/packages/${name}.tar.bz2";
    sha256 = "1faldxnh9dld5k0vxckwpqw241ya1r2zv286l6rpgqr500zqw7r1";
  };

  buildInputs = [ pkgconfig glib gtk2 popt babeltrace ];

  meta = with stdenv.lib; {
    description = "Graphical trace viewer for LTTng trace files";
    homepage = http://lttng.org/;
    # liblttvtraceread (ltt/ directory) is distributed under the GNU LGPL v2.1.
    # The rest of the LTTV package is distributed under the GNU GPL v2.
    # TODO license = with licenses; [ gpl2 lgpl21 ];
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };

}
