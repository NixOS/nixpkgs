{ stdenv, fetchurl, eventlog, pkgconfig, glib, python, systemd, perl
, riemann_c_client, protobufc, pcre, yacc, openssl }:

stdenv.mkDerivation rec {
  name = "syslog-ng-${version}";

  version = "3.8.1";

  src = fetchurl {
    url = "https://github.com/balabit/syslog-ng/releases/download/${name}/${name}.tar.gz";
    sha256 = "1iac49cmgv7ax4pw6plzpq7gxraxvk7jnd1f0m9br37rwpv83c44";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ eventlog glib python systemd perl riemann_c_client protobufc yacc pcre openssl ];

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
    platforms = platforms.linux;
  };
}
