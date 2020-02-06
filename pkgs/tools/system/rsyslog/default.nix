{ stdenv, fetchurl, pkgconfig, autoreconfHook, libestr, json_c, zlib, pythonPackages, fastJson
, libkrb5 ? null, systemd ? null, jemalloc ? null, libmysqlclient ? null, postgresql ? null
, libdbi ? null, net-snmp ? null, libuuid ? null, curl ? null, gnutls ? null
, libgcrypt ? null, liblognorm ? null, openssl ? null, librelp ? null, libksi ? null
, liblogging ? null, libnet ? null, hadoop ? null, rdkafka ? null
, libmongo-client ? null, czmq ? null, rabbitmq-c ? null, hiredis ? null, mongoc ? null
, libmaxminddb ? null
}:

with stdenv.lib;
let
  mkFlag = cond: name: if cond then "--enable-${name}" else "--disable-${name}";
in
stdenv.mkDerivation rec {
  pname = "rsyslog";
  version = "8.1911.0";

  src = fetchurl {
    url = "https://www.rsyslog.com/files/download/rsyslog/${pname}-${version}.tar.gz";
    sha256 = "01713vwz3w5fx9b97286h1rx9hxhjsdah96nyhh75bb23impgx71";
  };

  #patches = [ ./fix-gnutls-detection.patch ];

  nativeBuildInputs = [ pkgconfig autoreconfHook ];
  buildInputs = [
    fastJson libestr json_c zlib pythonPackages.docutils libkrb5 jemalloc
    postgresql libdbi net-snmp libuuid curl gnutls libgcrypt liblognorm openssl
    librelp libksi liblogging libnet hadoop rdkafka libmongo-client czmq
    rabbitmq-c hiredis mongoc libmaxminddb
  ] ++ stdenv.lib.optional (libmysqlclient != null) libmysqlclient
    ++ stdenv.lib.optional stdenv.isLinux systemd;

  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--with-systemdsystemunitdir=\${out}/etc/systemd/system"
    (mkFlag true                      "largefile")
    (mkFlag true                      "regexp")
    (mkFlag (libkrb5 != null)         "gssapi-krb5")
    (mkFlag true                      "klog")
    (mkFlag true                      "kmsg")
    (mkFlag (systemd != null)         "imjournal")
    (mkFlag true                      "inet")
    (mkFlag (jemalloc != null)        "jemalloc")
    (mkFlag true                      "unlimited-select")
    (mkFlag false                     "debug")
    (mkFlag false                     "debug-symbols")
    (mkFlag true                      "debugless")
    (mkFlag false                     "valgrind")
    (mkFlag false                     "diagtools")
    (mkFlag true                      "usertools")
    (mkFlag (libmysqlclient != null)  "mysql")
    (mkFlag (postgresql != null)      "pgsql")
    (mkFlag (libdbi != null)          "libdbi")
    (mkFlag (net-snmp != null)        "snmp")
    (mkFlag (libuuid != null)         "uuid")
    (mkFlag (curl != null)            "elasticsearch")
    (mkFlag (gnutls != null)          "gnutls")
    (mkFlag (libgcrypt != null)       "libgcrypt")
    (mkFlag true                      "rsyslogrt")
    (mkFlag true                      "rsyslogd")
    (mkFlag true                      "mail")
    (mkFlag (liblognorm != null)      "mmnormalize")
    (mkFlag (libmaxminddb != null)    "mmdblookup")
    (mkFlag true                      "mmjsonparse")
    (mkFlag true                      "mmaudit")
    (mkFlag true                      "mmanon")
    (mkFlag true                      "mmutf8fix")
    (mkFlag true                      "mmcount")
    (mkFlag true                      "mmsequence")
    (mkFlag true                      "mmfields")
    (mkFlag true                      "mmpstrucdata")
    (mkFlag (openssl != null)         "mmrfc5424addhmac")
    (mkFlag (librelp != null)         "relp")
    (mkFlag (libksi != null)          "ksi-ls12")
    (mkFlag (liblogging != null)      "liblogging-stdlog")
    (mkFlag (liblogging != null)      "rfc3195")
    (mkFlag true                      "imfile")
    (mkFlag false                     "imsolaris")
    (mkFlag true                      "imptcp")
    (mkFlag true                      "impstats")
    (mkFlag true                      "omprog")
    (mkFlag (libnet != null)          "omudpspoof")
    (mkFlag true                      "omstdout")
    (mkFlag (systemd != null)         "omjournal")
    (mkFlag true                      "pmlastmsg")
    (mkFlag true                      "pmcisconames")
    (mkFlag true                      "pmciscoios")
    (mkFlag true                      "pmaixforwardedfrom")
    (mkFlag true                      "pmsnare")
    (mkFlag true                      "omruleset")
    (mkFlag true                      "omuxsock")
    (mkFlag true                      "mmsnmptrapd")
    (mkFlag (hadoop != null)          "omhdfs")
    (mkFlag (rdkafka != null)         "omkafka")
    (mkFlag (libmongo-client != null) "ommongodb")
    (mkFlag (czmq != null)            "imczmq")
    (mkFlag (czmq != null)            "omczmq")
    (mkFlag (rabbitmq-c != null)      "omrabbitmq")
    (mkFlag (hiredis != null)         "omhiredis")
    (mkFlag (curl != null)            "omhttpfs")
    (mkFlag true                      "generate-man-pages")
  ];

  meta = {
    homepage = https://www.rsyslog.com/;
    description = "Enhanced syslog implementation";
    changelog = "https://raw.githubusercontent.com/rsyslog/rsyslog/v${version}/ChangeLog";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
