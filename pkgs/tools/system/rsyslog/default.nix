{stdenv, fetchurl, eventlog, pkgconfig, libestr, libee, json_c, libuuid, zlib, gnutls, libgcrypt, systemd, liblogging}:

stdenv.mkDerivation {
  name = "rsyslog-7.6.3";

  src = fetchurl {
    url = http://www.rsyslog.com/files/download/rsyslog/rsyslog-7.6.3.tar.gz;
    sha256 = "1v7mi2jjyn3awrfxqvd3mg64m5r027dgpbzd511mlvlbbw1mjcq1";
  };

  buildInputs = [pkgconfig libestr libee json_c libuuid zlib gnutls libgcrypt systemd liblogging];

  preConfigure = ''
     export configureFlags="$configureFlags --enable-gnutls --enable-cached-man-pages --enable-imjournal --with-systemdsystemunitdir=$out/etc/systemd/system"
  '';

  meta = {
    homepage = "http://www.rsyslog.com/";
    description = "Enhanced syslog implementation";
    license = "GPLv3";
    platforms = stdenv.lib.platforms.linux;
  };
}
