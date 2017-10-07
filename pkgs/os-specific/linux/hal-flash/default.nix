{ stdenv, fetchurl, autoconf, automake, dbus, glib, libtool, pkgconfig, udisks2 }:

stdenv.mkDerivation {
  name = "hal-flash-0.3.0";

  src = fetchurl {
    url = "https://github.com/cshorler/hal-flash/archive/v0.3.0.tar.gz";
    sha256 = "163pqy39cca8cnf8rm8zr63ndsnr7rki9pf9j7dl9gyxmi7sx88s";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ autoconf automake dbus glib libtool udisks2 ];

  preConfigure = "libtoolize && aclocal && autoconf && automake --add-missing";

  meta = with stdenv.lib; {
    homepage = https://github.com/cshorler/hal-flash;
    description = "libhal stub library to satisfy the Flash Player DRM requirements";
    longDescription =
      ''
        Stub library based loosely upon libhal.[ch] from the hal-0.5.14
        package.  Provides the minimum necessary functionality to enable
        libflashplayer.so/libadobecp.so to play back DRM content.
      '';
    license = with licenses; [ afl21 gpl2 ];
    maintainers = with maintainers; [ malyn ];
    platforms = platforms.linux;
  };
}
