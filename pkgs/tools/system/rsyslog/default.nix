{ stdenv, fetchurl, pkgconfig, autoreconfHook, libestr, json_c, zlib, pythonPackages, fastJson
, libkrb5 ? null, systemd ? null, jemalloc ? null, libmysql ? null, postgresql ? null
, libdbi ? null, net_snmp ? null, libuuid ? null, curl ? null, gnutls ? null
, libgcrypt ? null, liblognorm ? null, openssl ? null, librelp ? null, libksi ? null
, libgt ? null, liblogging ? null, libnet ? null, hadoop ? null, rdkafka ? null
, libmongo-client ? null, czmq ? null, rabbitmq-c ? null, hiredis ? null
}:

with stdenv.lib;
let
  mkFlag = cond: name: if cond then "--enable-${name}" else "--disable-${name}";
in
stdenv.mkDerivation rec {
  name = "rsyslog-8.21.0";

  src = fetchurl {
    url = "http://www.rsyslog.com/files/download/rsyslog/${name}.tar.gz";
    sha256 = "1arrhc9fw79sp7dxkf7gyfwibyr2i1000pfds5c7n43mgglgvcdx";
  };

  #patches = [ ./fix-gnutls-detection.patch ];

  nativeBuildInputs = [ pkgconfig autoreconfHook ];
  buildInputs = [
    fastJson libestr json_c zlib pythonPackages.docutils libkrb5 jemalloc libmysql
    postgresql libdbi net_snmp libuuid curl gnutls libgcrypt liblognorm openssl
    librelp libgt libksi liblogging libnet hadoop rdkafka libmongo-client czmq
    rabbitmq-c hiredis
  ] ++ stdenv.lib.optional stdenv.isLinux systemd;

  hardeningDisable = [ "format" ];

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
    (mkFlag (libmysql != null)        "mysql")
    (mkFlag (postgresql != null)      "pgsql")
    (mkFlag (libdbi != null)          "libdbi")
    (mkFlag (net_snmp != null)        "snmp")
    (mkFlag (libuuid != null)         "uuid")
    (mkFlag (curl != null)            "elasticsearch")
    (mkFlag (gnutls != null)          "gnutls")
    (mkFlag (libgcrypt != null)       "libgcrypt")
    (mkFlag true                      "rsyslogrt")
    (mkFlag true                      "rsyslogd")
    (mkFlag true                      "mail")
    (mkFlag (liblognorm != null)      "mmnormalize")
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
    (mkFlag (libgt != null)           "guardtime")
    (mkFlag (libksi != null)          "gt-ksi")
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
    (mkFlag (czmq != null)            "imzmq3")
    (mkFlag (czmq != null)            "imczmq")
    (mkFlag (czmq != null)            "omzmq3")
    (mkFlag (czmq != null)            "omczmq")
    (mkFlag (rabbitmq-c != null)      "omrabbitmq")
    (mkFlag (hiredis != null)         "omhiredis")
    (mkFlag (curl != null)            "omhttpfs")
    (mkFlag true                      "generate-man-pages")
  ];

  meta = {
    homepage = "http://www.rsyslog.com/";
    description = "Enhanced syslog implementation";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ wkennington ];
  };
}
