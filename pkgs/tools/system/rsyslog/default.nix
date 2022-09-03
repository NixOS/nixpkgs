{ lib, stdenv, fetchurl, pkg-config, autoreconfHook, libestr, json_c, zlib, docutils, fastJson
, libkrb5 ? null, systemd ? null, jemalloc ? null, libmysqlclient ? null, postgresql ? null
, libdbi ? null, net-snmp ? null, libuuid ? null, curl ? null, gnutls ? null
, libgcrypt ? null, liblognorm ? null, openssl ? null, librelp ? null, libksi ? null
, liblogging ? null, libnet ? null, hadoop ? null, rdkafka ? null
, libmongo-client ? null, czmq ? null, rabbitmq-c ? null, hiredis ? null, mongoc ? null
, libmaxminddb ? null
, nixosTests ? null
}:

with lib;
stdenv.mkDerivation rec {
  pname = "rsyslog";
  version = "8.2208.0";

  src = fetchurl {
    url = "https://www.rsyslog.com/files/download/rsyslog/${pname}-${version}.tar.gz";
    sha256 = "sha256-FN5o57jlqwxdc0+C4tyf/yLNf0cQrWkHJ+sQp7mz314=";
  };

  #patches = [ ./fix-gnutls-detection.patch ];

  nativeBuildInputs = [ pkg-config autoreconfHook ];
  buildInputs = [
    fastJson libestr json_c zlib docutils libkrb5 jemalloc
    postgresql libdbi net-snmp libuuid curl gnutls libgcrypt liblognorm openssl
    librelp libksi liblogging libnet hadoop rdkafka libmongo-client czmq
    rabbitmq-c hiredis mongoc libmaxminddb
  ] ++ lib.optional (libmysqlclient != null) libmysqlclient
    ++ lib.optional stdenv.isLinux systemd;

  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--with-systemdsystemunitdir=\${out}/etc/systemd/system"
    (enableFeature true                      "largefile")
    (enableFeature true                      "regexp")
    (enableFeature (libkrb5 != null)         "gssapi-krb5")
    (enableFeature true                      "klog")
    (enableFeature true                      "kmsg")
    (enableFeature (systemd != null)         "imjournal")
    (enableFeature true                      "inet")
    (enableFeature (jemalloc != null)        "jemalloc")
    (enableFeature true                      "unlimited-select")
    (enableFeature false                     "debug")
    (enableFeature false                     "debug-symbols")
    (enableFeature true                      "debugless")
    (enableFeature false                     "valgrind")
    (enableFeature false                     "diagtools")
    (enableFeature true                      "usertools")
    (enableFeature (libmysqlclient != null)  "mysql")
    (enableFeature (postgresql != null)      "pgsql")
    (enableFeature (libdbi != null)          "libdbi")
    (enableFeature (net-snmp != null)        "snmp")
    (enableFeature (libuuid != null)         "uuid")
    (enableFeature (curl != null)            "elasticsearch")
    (enableFeature (gnutls != null)          "gnutls")
    (enableFeature (libgcrypt != null)       "libgcrypt")
    (enableFeature true                      "rsyslogrt")
    (enableFeature true                      "rsyslogd")
    (enableFeature true                      "mail")
    (enableFeature (liblognorm != null)      "mmnormalize")
    (enableFeature (libmaxminddb != null)    "mmdblookup")
    (enableFeature true                      "mmjsonparse")
    (enableFeature true                      "mmaudit")
    (enableFeature true                      "mmanon")
    (enableFeature true                      "mmutf8fix")
    (enableFeature true                      "mmcount")
    (enableFeature true                      "mmsequence")
    (enableFeature true                      "mmfields")
    (enableFeature true                      "mmpstrucdata")
    (enableFeature (openssl != null)         "mmrfc5424addhmac")
    (enableFeature (librelp != null)         "relp")
    (enableFeature (libksi != null)          "ksi-ls12")
    (enableFeature (liblogging != null)      "liblogging-stdlog")
    (enableFeature (liblogging != null)      "rfc3195")
    (enableFeature true                      "imfile")
    (enableFeature false                     "imsolaris")
    (enableFeature true                      "imptcp")
    (enableFeature true                      "impstats")
    (enableFeature true                      "omprog")
    (enableFeature (libnet != null)          "omudpspoof")
    (enableFeature true                      "omstdout")
    (enableFeature (systemd != null)         "omjournal")
    (enableFeature true                      "pmlastmsg")
    (enableFeature true                      "pmcisconames")
    (enableFeature true                      "pmciscoios")
    (enableFeature true                      "pmaixforwardedfrom")
    (enableFeature true                      "pmsnare")
    (enableFeature true                      "omruleset")
    (enableFeature true                      "omuxsock")
    (enableFeature true                      "mmsnmptrapd")
    (enableFeature (hadoop != null)          "omhdfs")
    (enableFeature (rdkafka != null)         "omkafka")
    (enableFeature (libmongo-client != null) "ommongodb")
    (enableFeature (czmq != null)            "imczmq")
    (enableFeature (czmq != null)            "omczmq")
    (enableFeature (rabbitmq-c != null)      "omrabbitmq")
    (enableFeature (hiredis != null)         "omhiredis")
    (enableFeature (curl != null)            "omhttpfs")
    (enableFeature true                      "generate-man-pages")
  ];

  passthru.tests = {
    nixos-rsyslogd = nixosTests.rsyslogd;
  };

  meta = {
    homepage = "https://www.rsyslog.com/";
    description = "Enhanced syslog implementation";
    changelog = "https://raw.githubusercontent.com/rsyslog/rsyslog/v${version}/ChangeLog";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
