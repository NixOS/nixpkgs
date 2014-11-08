{ stdenv, fetchurl, eventlog, pkgconfig, glib, python, systemd, perl
, riemann_c_client, protobufc, yacc }:

stdenv.mkDerivation rec {
  name = "syslog-ng-${version}";

  version = "3.6.1";

  src = fetchurl {
    url = "http://www.balabit.com/downloads/files?path=/syslog-ng/sources/${version}/source/syslog-ng_${version}.tar.gz";
    sha256 = "1s3lsxk2pky3jkfamkw5ivpxq2kazikcvdgpmxiyn5w10dwkd0m7";
  };

  buildInputs = [ eventlog pkgconfig glib python systemd perl riemann_c_client protobufc yacc ];

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
