{stdenv, fetchurl, eventlog, pkgconfig, libestr, libee, json_c, libuuid, zlib, gnutls}:

stdenv.mkDerivation {
  name = "rsyslog-7.2.7";

  src = fetchurl {
    url = http://www.rsyslog.com/files/download/rsyslog/rsyslog-7.2.7.tar.gz;
    sha256 = "0vgrbbklsvnwcy0m0kbxcj5lhpn2k9bsv0lh0vnyn6hc2hx56cs8";
  };

  buildInputs = [pkgconfig libestr libee json_c libuuid zlib gnutls];

  configureFlags = "--enable-gnutls";

  meta = {
    homepage = "http://www.rsyslog.com/";
    description = "Enhanced syslog implementation";
    license = "GPLv3";
    platforms = stdenv.lib.platforms.linux;
  };
}
