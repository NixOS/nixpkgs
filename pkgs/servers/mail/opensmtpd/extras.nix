{ stdenv, fetchurl, openssl, libevent, libasr,
  python2, pkgconfig, lua5, perl, mariadb, postgresql, sqlite, hiredis }:
stdenv.mkDerivation rec {
  name = "opensmtpd-extras-${version}";
  version = "5.7.1";

  src = fetchurl {
    url = "https://www.opensmtpd.org/archives/${name}.tar.gz";
    sha256 = "1kld4hxgz792s0cb2gl7m2n618ikzqkj88w5dhaxdrxg4x2c4vdm";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ openssl libevent
    libasr python2 lua5 perl mariadb postgresql sqlite hiredis ];

  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--with-privsep-user=smtpd"
    "--with-libevent-dir=${libevent.dev}"

    "--with-filter-clamav"
    "--with-filter-dkim-signer"
    "--with-filter-dnsbl"
    "--with-filter-monkey"
    "--with-filter-pause"
    "--with-filter-regex"
    "--with-filter-spamassassin"
    "--with-filter-stub"
    "--with-filter-trace"
    "--with-filter-void"
    "--with-queue-null"
    "--with-queue-ram"
    "--with-queue-stub"
    "--with-table-ldap"
    "--with-table-socketmap"
    "--with-table-passwd"
    "--with-table-stub"
    "--with-scheduler-ram"
    "--with-scheduler-stub"

  ] ++ stdenv.lib.optional (python2 != null) [
    "--with-python=${python2}"
    "--with-filter-python"
    "--with-queue-python"
    "--with-table-python"
    "--with-scheduler-python"

  ] ++ stdenv.lib.optional (lua5 != null) [
    "--with-lua=${pkgconfig}"
    "--with-filter-lua"

  ] ++ stdenv.lib.optional (perl != null) [
    "--with-perl=${perl}"
    "--with-filter-perl"

  ] ++ stdenv.lib.optional (mariadb != null) [
    "--with-table-mysql"

  ] ++ stdenv.lib.optional (postgresql != null) [
    "--with-table-postgres"

  ] ++ stdenv.lib.optional (sqlite != null) [
    "--with-table-sqlite"

  ] ++ stdenv.lib.optional (hiredis != null) [
    "--with-table-redis"
  ];

  NIX_CFLAGS_COMPILE = stdenv.lib.optional (hiredis != null) [ "-I${hiredis}/include/hiredis" ];

  meta = with stdenv.lib; {
    homepage = https://www.opensmtpd.org/;
    description = "Extra plugins for the OpenSMTPD mail server";
    license = licenses.isc;
    platforms = platforms.unix;
    maintainers = with maintainers; [ gebner ];
  };
}
