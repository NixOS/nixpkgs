{ stdenv, fetchurl, eventlog, pkgconfig, glib, python, systemd, perl
, riemann_c_client, protobufc, pcre, yacc }:

stdenv.mkDerivation rec {
  name = "syslog-ng-${version}";

  version = "3.6.2";

  src = fetchurl {
    url = "http://www.balabit.com/downloads/files?path=/syslog-ng/sources/${version}/source/syslog-ng_${version}.tar.gz";
    sha256 = "0qc21mwajk6xrra3gqy2nvaza5gq62psamq4ayphj7lqabdglizg";
  };

  buildInputs = [ eventlog pkgconfig glib python systemd perl riemann_c_client protobufc yacc pcre ];

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
