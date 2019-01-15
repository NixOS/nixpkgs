{ stdenv, fetchzip, libpcap, glib, pkgconfig, libnet }:
stdenv.mkDerivation {
  pname = "libnids";
  version = "1.24";
  src = fetchzip {
    url = "mirror://sourceforge/libnids/libnids-1.24.tar.gz";
    sha256 = "1cblklfdfxcmy0an6xyyzx4l877xdawhjd28daqfsvrh81mb07k1";
  };
  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libpcap glib libnet ];

  /*
  Quoting the documentation of glib: g_thread_init has been deprecated since
  version 2.32 and should not be used in newly-written code.  This function is
  no longer necessary. The GLib threading system is automatically initialized
  at the start of your program.

  this is necessary for dsniff to compile; otherwise g_thread_init is a missing
  symbol when linking (?!?)
  */
  NIX_CFLAGS_COMPILE="-Dg_thread_init= ";

  meta = with stdenv.lib; {
    description = "An E-component of Network Intrusion Detection System which emulates the IP stack of Linux 2.0.x";
    homepage = http://libnids.sourceforge.net/;
    license = licenses.gpl2;
    maintainers = [ maintainers.symphorien ];
    # probably also bsd and solaris
    platforms = platforms.linux;
  };
}
