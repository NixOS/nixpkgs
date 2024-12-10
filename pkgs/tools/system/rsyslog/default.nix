{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  autoreconfHook,
  libestr,
  json_c,
  zlib,
  docutils,
  fastJson,
  withKrb5 ? true,
  libkrb5,
  withSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd,
  systemd,
  withJemalloc ? true,
  jemalloc,
  withMysql ? true,
  libmysqlclient,
  withPostgres ? true,
  postgresql,
  withDbi ? true,
  libdbi,
  withNetSnmp ? true,
  net-snmp,
  withUuid ? true,
  libuuid,
  withCurl ? true,
  curl,
  withGnutls ? true,
  gnutls,
  withGcrypt ? true,
  libgcrypt,
  withLognorm ? true,
  liblognorm,
  withMaxminddb ? true,
  libmaxminddb,
  withOpenssl ? true,
  openssl,
  withRelp ? true,
  librelp,
  withKsi ? true,
  libksi,
  withLogging ? true,
  liblogging,
  withNet ? true,
  libnet,
  withHadoop ? true,
  hadoop,
  withRdkafka ? true,
  rdkafka,
  withMongo ? true,
  mongoc,
  withCzmq ? true,
  czmq,
  withRabbitmq ? true,
  rabbitmq-c,
  withHiredis ? true,
  hiredis,
  nixosTests,
}:

stdenv.mkDerivation rec {
  pname = "rsyslog";
  version = "8.2408.0";

  src = fetchurl {
    url = "https://www.rsyslog.com/files/download/rsyslog/${pname}-${version}.tar.gz";
    hash = "sha256-i7LxX5v5u35jUYLj0+Nwv8OdCL81o2fc6XFOGG94cgY=";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
    docutils
  ];

  buildInputs =
    [
      fastJson
      libestr
      json_c
      zlib
    ]
    ++ lib.optional withKrb5 libkrb5
    ++ lib.optional withJemalloc jemalloc
    ++ lib.optional withPostgres postgresql
    ++ lib.optional withDbi libdbi
    ++ lib.optional withNetSnmp net-snmp
    ++ lib.optional withUuid libuuid
    ++ lib.optional withCurl curl
    ++ lib.optional withGnutls gnutls
    ++ lib.optional withGcrypt libgcrypt
    ++ lib.optional withLognorm liblognorm
    ++ lib.optional withOpenssl openssl
    ++ lib.optional withRelp librelp
    ++ lib.optional withKsi libksi
    ++ lib.optional withLogging liblogging
    ++ lib.optional withNet libnet
    ++ lib.optional withHadoop hadoop
    ++ lib.optional withRdkafka rdkafka
    ++ lib.optionals withMongo [ mongoc ]
    ++ lib.optional withCzmq czmq
    ++ lib.optional withRabbitmq rabbitmq-c
    ++ lib.optional withHiredis hiredis
    ++ lib.optional withMaxminddb libmaxminddb
    ++ lib.optional withMysql libmysqlclient
    ++ lib.optional withSystemd systemd;

  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--with-systemdsystemunitdir=\${out}/etc/systemd/system"
    (lib.enableFeature true "largefile")
    (lib.enableFeature true "regexp")
    (lib.enableFeature withKrb5 "gssapi-krb5")
    (lib.enableFeature true "klog")
    (lib.enableFeature true "kmsg")
    (lib.enableFeature withSystemd "imjournal")
    (lib.enableFeature true "inet")
    (lib.enableFeature withJemalloc "jemalloc")
    (lib.enableFeature true "unlimited-select")
    (lib.enableFeature withCurl "clickhouse")
    (lib.enableFeature false "debug")
    (lib.enableFeature false "debug-symbols")
    (lib.enableFeature true "debugless")
    (lib.enableFeature false "valgrind")
    (lib.enableFeature false "diagtools")
    (lib.enableFeature withCurl "fmhttp")
    (lib.enableFeature true "usertools")
    (lib.enableFeature withMysql "mysql")
    (lib.enableFeature withPostgres "pgsql")
    (lib.enableFeature withDbi "libdbi")
    (lib.enableFeature withNetSnmp "snmp")
    (lib.enableFeature withUuid "uuid")
    (lib.enableFeature withCurl "elasticsearch")
    (lib.enableFeature withGnutls "gnutls")
    (lib.enableFeature withGcrypt "libgcrypt")
    (lib.enableFeature true "rsyslogrt")
    (lib.enableFeature true "rsyslogd")
    (lib.enableFeature true "mail")
    (lib.enableFeature withLognorm "mmnormalize")
    (lib.enableFeature withMaxminddb "mmdblookup")
    (lib.enableFeature true "mmjsonparse")
    (lib.enableFeature true "mmaudit")
    (lib.enableFeature true "mmanon")
    (lib.enableFeature true "mmutf8fix")
    (lib.enableFeature true "mmcount")
    (lib.enableFeature true "mmsequence")
    (lib.enableFeature true "mmfields")
    (lib.enableFeature true "mmpstrucdata")
    (lib.enableFeature withOpenssl "mmrfc5424addhmac")
    (lib.enableFeature withRelp "relp")
    (lib.enableFeature withKsi "ksi-ls12")
    (lib.enableFeature withLogging "liblogging-stdlog")
    (lib.enableFeature withLogging "rfc3195")
    (lib.enableFeature true "imfile")
    (lib.enableFeature false "imsolaris")
    (lib.enableFeature true "imptcp")
    (lib.enableFeature true "impstats")
    (lib.enableFeature true "omprog")
    (lib.enableFeature withNet "omudpspoof")
    (lib.enableFeature true "omstdout")
    (lib.enableFeature withSystemd "omjournal")
    (lib.enableFeature true "pmlastmsg")
    (lib.enableFeature true "pmcisconames")
    (lib.enableFeature true "pmciscoios")
    (lib.enableFeature true "pmaixforwardedfrom")
    (lib.enableFeature true "pmsnare")
    (lib.enableFeature true "omruleset")
    (lib.enableFeature true "omuxsock")
    (lib.enableFeature true "mmsnmptrapd")
    (lib.enableFeature withHadoop "omhdfs")
    (lib.enableFeature withRdkafka "omkafka")
    (lib.enableFeature withMongo "ommongodb")
    (lib.enableFeature withCzmq "imczmq")
    (lib.enableFeature withCzmq "omczmq")
    (lib.enableFeature withRabbitmq "omrabbitmq")
    (lib.enableFeature withHiredis "omhiredis")
    (lib.enableFeature withCurl "omhttp")
    (lib.enableFeature true "generate-man-pages")
  ];

  passthru.tests = {
    nixos-rsyslogd = nixosTests.rsyslogd;
  };

  meta = {
    homepage = "https://www.rsyslog.com/";
    description = "Enhanced syslog implementation";
    mainProgram = "rsyslogd";
    changelog = "https://raw.githubusercontent.com/rsyslog/rsyslog/v${version}/ChangeLog";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
}
