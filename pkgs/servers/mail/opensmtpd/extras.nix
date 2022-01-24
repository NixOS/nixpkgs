{ lib, stdenv, fetchurl, openssl, libevent, libasr, ncurses,
  pkg-config, lua5, perl, libmysqlclient, postgresql, sqlite, hiredis,
  enableLua ? true,
  enablePerl ? true,
  enableMysql ? true,
  enablePostgres ? true,
  enableSqlite ? true,
  enableRedis ? true,
}:

stdenv.mkDerivation rec {
  pname = "opensmtpd-extras";
  version = "6.7.1";

  src = fetchurl {
    url = "https://www.opensmtpd.org/archives/${pname}-${version}.tar.gz";
    sha256 = "1b1mx71bvmv92lbm08wr2p60g3qhikvv3n15zsr6dcwbk9aqahzq";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl libevent
    libasr lua5 perl libmysqlclient postgresql sqlite hiredis ];

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

  ] ++ lib.optionals enableLua [
    "--with-lua=${pkg-config}"
    "--with-filter-lua"

  ] ++ lib.optionals enablePerl [
    "--with-perl=${perl}"
    "--with-filter-perl"

  ] ++ lib.optionals enableMysql [
    "--with-table-mysql"

  ] ++ lib.optionals enablePostgres [
    "--with-table-postgres"

  ] ++ lib.optionals enableSqlite [
    "--with-table-sqlite"

  ] ++ lib.optionals enableRedis [
    "--with-table-redis"
  ];

  NIX_CFLAGS_COMPILE = lib.optionalString enableRedis
      "-I${hiredis}/include/hiredis -lhiredis"
    + lib.optionalString enableMysql
      " -L${libmysqlclient}/lib/mysql";

  meta = with lib; {
    homepage = "https://www.opensmtpd.org/";
    description = "Extra plugins for the OpenSMTPD mail server";
    license = licenses.isc;
    platforms = platforms.linux;
    maintainers = with maintainers; [ gebner ekleog ];
  };
}
