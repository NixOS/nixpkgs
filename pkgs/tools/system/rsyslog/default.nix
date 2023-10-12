{ lib
, stdenv
, fetchurl
, pkg-config
, autoreconfHook
, libestr
, json_c
, zlib
, docutils
, fastJson
, withKrb5 ? true
, libkrb5
, withSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd
, systemd
, withJemalloc ? true
, jemalloc
, withMysql ? true
, libmysqlclient
, withPostgres ? true
, postgresql
, withDbi ? true
, libdbi
, withNetSnmp ? true
, net-snmp
, withUuid ? true
, libuuid
, withCurl ? true
, curl
, withGnutls ? true
, gnutls
, withGcrypt ? true
, libgcrypt
, withLognorm ? true
, liblognorm
, withMaxminddb ? true
, libmaxminddb
, withOpenssl ? true
, openssl
, withRelp ? true
, librelp
, withKsi ? true
, libksi
, withLogging ? true
, liblogging
, withNet ? true
, libnet
, withHadoop ? true
, hadoop
, withRdkafka ? true
, rdkafka
, withMongo ? true
, mongoc
, withCzmq ? true
, czmq
, withRabbitmq ? true
, rabbitmq-c
, withHiredis ? true
, hiredis
, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "rsyslog";
  version = "8.2308.0";

  src = fetchurl {
    url = "https://www.rsyslog.com/files/download/rsyslog/${pname}-${version}.tar.gz";
    hash = "sha256-AghrkSHocs6mnl0PbI4tjr/zMjSzytVQNmU3jTry48k=";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
    docutils
  ];

  buildInputs = [
    fastJson
    libestr
    json_c
    zlib
  ] ++ lib.optional withKrb5 libkrb5
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

  configureFlags = with lib; [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--with-systemdsystemunitdir=\${out}/etc/systemd/system"
    (enableFeature true "largefile")
    (enableFeature true "regexp")
    (enableFeature withKrb5 "gssapi-krb5")
    (enableFeature true "klog")
    (enableFeature true "kmsg")
    (enableFeature withSystemd "imjournal")
    (enableFeature true "inet")
    (enableFeature withJemalloc "jemalloc")
    (enableFeature true "unlimited-select")
    (enableFeature withCurl "clickhouse")
    (enableFeature false "debug")
    (enableFeature false "debug-symbols")
    (enableFeature true "debugless")
    (enableFeature false "valgrind")
    (enableFeature false "diagtools")
    (enableFeature withCurl "fmhttp")
    (enableFeature true "usertools")
    (enableFeature withMysql "mysql")
    (enableFeature withPostgres "pgsql")
    (enableFeature withDbi "libdbi")
    (enableFeature withNetSnmp "snmp")
    (enableFeature withUuid "uuid")
    (enableFeature withCurl "elasticsearch")
    (enableFeature withGnutls "gnutls")
    (enableFeature withGcrypt "libgcrypt")
    (enableFeature true "rsyslogrt")
    (enableFeature true "rsyslogd")
    (enableFeature true "mail")
    (enableFeature withLognorm "mmnormalize")
    (enableFeature withMaxminddb "mmdblookup")
    (enableFeature true "mmjsonparse")
    (enableFeature true "mmaudit")
    (enableFeature true "mmanon")
    (enableFeature true "mmutf8fix")
    (enableFeature true "mmcount")
    (enableFeature true "mmsequence")
    (enableFeature true "mmfields")
    (enableFeature true "mmpstrucdata")
    (enableFeature withOpenssl "mmrfc5424addhmac")
    (enableFeature withRelp "relp")
    (enableFeature withKsi "ksi-ls12")
    (enableFeature withLogging "liblogging-stdlog")
    (enableFeature withLogging "rfc3195")
    (enableFeature true "imfile")
    (enableFeature false "imsolaris")
    (enableFeature true "imptcp")
    (enableFeature true "impstats")
    (enableFeature true "omprog")
    (enableFeature withNet "omudpspoof")
    (enableFeature true "omstdout")
    (enableFeature withSystemd "omjournal")
    (enableFeature true "pmlastmsg")
    (enableFeature true "pmcisconames")
    (enableFeature true "pmciscoios")
    (enableFeature true "pmaixforwardedfrom")
    (enableFeature true "pmsnare")
    (enableFeature true "omruleset")
    (enableFeature true "omuxsock")
    (enableFeature true "mmsnmptrapd")
    (enableFeature withHadoop "omhdfs")
    (enableFeature withRdkafka "omkafka")
    (enableFeature withMongo "ommongodb")
    (enableFeature withCzmq "imczmq")
    (enableFeature withCzmq "omczmq")
    (enableFeature withRabbitmq "omrabbitmq")
    (enableFeature withHiredis "omhiredis")
    (enableFeature withCurl "omhttp")
    (enableFeature true "generate-man-pages")
  ];

  passthru.tests = {
    nixos-rsyslogd = nixosTests.rsyslogd;
  };

  meta = with lib; {
    homepage = "https://www.rsyslog.com/";
    description = "Enhanced syslog implementation";
    changelog = "https://raw.githubusercontent.com/rsyslog/rsyslog/v${version}/ChangeLog";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ];
  };
}
