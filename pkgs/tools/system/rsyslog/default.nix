{stdenv, fetchurl, eventlog, pkgconfig, libestr, libee, json_c, libuuid, zlib, gnutls, libgcrypt, systemd}:

stdenv.mkDerivation {
  name = "rsyslog-7.4.7";

  src = fetchurl {
    url = http://www.rsyslog.com/files/download/rsyslog/rsyslog-7.4.7.tar.gz;
    sha256 = "5fc7f930fa748bb6a9d86a3fc831eb1a14107db81b67d79ba8f113cf2776fa21";
  };

  buildInputs = [pkgconfig libestr libee json_c libuuid zlib gnutls libgcrypt systemd];

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
