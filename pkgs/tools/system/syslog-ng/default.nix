{ stdenv, fetchgit, autoconf, autoconf-archive, automake, libtool, flex, openssl
, eventlog, pkgconfig, glib, python, systemd, perl
, riemann_c_client, protobufc, pcre, yacc, which }:

stdenv.mkDerivation rec {
  name = "syslog-ng-${version}";
  version = "3.9.1";

  src = fetchgit {
    url = "https://github.com/balabit/syslog-ng.git";
    rev = "59aa4e5d9396d293aae021746214b97d7fe0a8ee"; # tag: syslog-ng-3.9.1
    sha256 = "15lalqf6dmpm4nr1pp0f2p0a6wbckkrh1k83vhp9ws0by5m8m66r";
  };

  buildInputs = [
    autoconf
    autoconf-archive
    automake
    libtool
    which
    flex
    openssl
    eventlog
    pkgconfig
    glib
    python
    systemd
    perl
    riemann_c_client
    protobufc
    yacc
    pcre
  ];

  preConfigure = ''
    ./autogen.sh
  '';

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
