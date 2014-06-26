{ stdenv, fetchurl, eventlog, pkgconfig, glib, python, systemd, perl }:

stdenv.mkDerivation {
  name = "syslog-ng-3.5.4.1";

  src = fetchurl {
    url = "http://www.balabit.com/downloads/files?path=/syslog-ng/sources/3.5.4.1/source/syslog-ng_3.5.4.1.tar.gz";
    sha256 = "0rkgrmnyx1x6m3jw5n49k7r1dcg79lxh900g74rgvd3j86g9dilj";
  };

  buildInputs = [ eventlog pkgconfig glib python systemd perl ];

  configureFlags = [
    "--enable-dynamic-linking"
    "--enable-systemd"
    "--with-systemdsystemunitdir=$(out)/etc/systemd/system"
  ];

  meta = {
    homepage = "http://www.balabit.com/network-security/syslog-ng/";
    description = "Next-generation syslogd with advanced networking and filtering capabilities";
    license = "GPLv2";
  };
}
