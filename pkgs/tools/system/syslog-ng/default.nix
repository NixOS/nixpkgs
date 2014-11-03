{ stdenv, fetchurl, eventlog, pkgconfig, glib, python, systemd, perl }:

stdenv.mkDerivation rec {
  name = "syslog-ng-${version}";

  version = "3.5.6";

  src = fetchurl {
    url = "http://www.balabit.com/downloads/files?path=/syslog-ng/sources/${version}/source/syslog-ng_${version}.tar.gz";
    sha256 = "19i1idklpgn6mz0mg7194by5fjgvvh5n4v2a0rr1z0778l2038kc";
  };

  buildInputs = [ eventlog pkgconfig glib python systemd perl ];

  configureFlags = [
    "--enable-dynamic-linking"
    "--enable-systemd"
    "--with-systemdsystemunitdir=$(out)/etc/systemd/system"
  ];

  meta = with stdenv.lib; {
    homepage = "http://www.balabit.com/network-security/syslog-ng/";
    description = "Next-generation syslogd with advanced networking and filtering capabilities";
    license = licenses.gpl2;
    maintainers = [ maintainers.rickynils ];
  };
}
