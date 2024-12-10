{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  autoreconfHook,
  libtool,
  libpcap,
  libcdada,
  # Optional Dependencies
  withJansson ? true,
  jansson,
  withNflog ? true,
  libnetfilter_log,
  withSQLite ? true,
  sqlite,
  withPgSQL ? true,
  postgresql,
  withMysql ? true,
  libmysqlclient,
  zlib,
  numactl,
  gnutlsSupport ? false,
  gnutls,
  testers,
  pmacct,
}:

stdenv.mkDerivation rec {
  version = "1.7.8";
  pname = "pmacct";

  src = fetchFromGitHub {
    owner = "pmacct";
    repo = "pmacct";
    rev = "v${version}";
    hash = "sha256-AcgZ5/8d1U/zGs4QeOkgkZS7ttCW6gtUv/Xuf4O4VE0=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    libtool
  ];
  buildInputs =
    [
      libcdada
      libpcap
    ]
    ++ lib.optional withJansson jansson
    ++ lib.optional withNflog libnetfilter_log
    ++ lib.optional withSQLite sqlite
    ++ lib.optional withPgSQL postgresql
    ++ lib.optionals withMysql [
      libmysqlclient
      zlib
      numactl
    ]
    ++ lib.optional gnutlsSupport gnutls;

  MYSQL_CONFIG = lib.optionalString withMysql "${lib.getDev libmysqlclient}/bin/mysql_config";

  configureFlags =
    [
      "--with-pcap-includes=${libpcap}/include"
    ]
    ++ lib.optional withJansson "--enable-jansson"
    ++ lib.optional withNflog "--enable-nflog"
    ++ lib.optional withSQLite "--enable-sqlite3"
    ++ lib.optional withPgSQL "--enable-pgsql"
    ++ lib.optional withMysql "--enable-mysql"
    ++ lib.optional gnutlsSupport "--enable-gnutls";

  passthru.tests = {
    version = testers.testVersion {
      package = pmacct;
      command = "pmacct -V";
    };
  };

  meta = with lib; {
    description = "A small set of multi-purpose passive network monitoring tools";
    longDescription = ''
      pmacct is a small set of multi-purpose passive network monitoring tools
      [NetFlow IPFIX sFlow libpcap BGP BMP RPKI IGP Streaming Telemetry]
    '';
    homepage = "http://www.pmacct.net/";
    changelog = "https://github.com/pmacct/pmacct/blob/v${version}/ChangeLog";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ _0x4A6F ];
    platforms = platforms.unix;
  };
}
