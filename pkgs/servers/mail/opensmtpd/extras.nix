{ stdenv, fetchurl, openssl, libevent, libasr,
  python2, pkgconfig, lua5, perl, libmysqlclient, postgresql, sqlite, hiredis,
  enablePython ? true,
  enableLua ? true,
  enablePerl ? true,
  enableMysql ? true,
  enablePostgres ? true,
  enableSqlite ? true,
  enableRedis ? true,
}:

stdenv.mkDerivation rec {
  pname = "opensmtpd-extras";
  version = "6.4.0";

  src = fetchurl {
    url = "https://www.opensmtpd.org/archives/${pname}-${version}.tar.gz";
    sha256 = "09k25l7zy5ch3fk6qphni2h0rxdp8wacmfag1whi608dgimrhrnb";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ openssl libevent
    libasr python2 lua5 perl libmysqlclient postgresql sqlite hiredis ];

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

  ] ++ stdenv.lib.optionals enablePython [
    "--with-python=${python2}"
    "--with-filter-python"
    "--with-queue-python"
    "--with-table-python"
    "--with-scheduler-python"

  ] ++ stdenv.lib.optionals enableLua [
    "--with-lua=${pkgconfig}"
    "--with-filter-lua"

  ] ++ stdenv.lib.optionals enablePerl [
    "--with-perl=${perl}"
    "--with-filter-perl"

  ] ++ stdenv.lib.optionals enableMysql [
    "--with-table-mysql"

  ] ++ stdenv.lib.optionals enablePostgres [
    "--with-table-postgres"

  ] ++ stdenv.lib.optionals enableSqlite [
    "--with-table-sqlite"

  ] ++ stdenv.lib.optionals enableRedis [
    "--with-table-redis"
  ];

  NIX_CFLAGS_COMPILE = stdenv.lib.optionalString enableRedis
      "-I${hiredis}/include/hiredis -lhiredis"
    + stdenv.lib.optionalString enableMysql
      " -L${libmysqlclient}/lib/mysql";

  meta = with stdenv.lib; {
    homepage = https://www.opensmtpd.org/;
    description = "Extra plugins for the OpenSMTPD mail server";
    license = licenses.isc;
    platforms = platforms.linux;
    maintainers = with maintainers; [ gebner ekleog ];
  };
}
