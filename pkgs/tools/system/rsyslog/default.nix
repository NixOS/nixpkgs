{stdenv, fetchurl, eventlog, pkgconfig, libestr, libee, json_c, libuuid, zlib, gnutls}:

stdenv.mkDerivation {
  name = "rsyslog-7.2.6";

  src = fetchurl {
    url = http://www.rsyslog.com/files/download/rsyslog/rsyslog-7.2.6.tar.gz;
    sha256 = "19a5c60816ebce6c86468eb8c5fe1c4cc1febf23c9167ce59d2327fe5e047ed9";
  };

  buildInputs = [pkgconfig libestr libee json_c libuuid zlib gnutls];

  configureFlags = "--enable-gnutls";

  meta = {
    homepage = "http://www.rsyslog.com/";
    description = "Rsyslog is an enhanced syslogd. It can be used as a drop-in replacement for stock sysklogd.";
    license = "GPLv3";

    platforms = stdenv.lib.platforms.linux;
  };
}
