{ stdenv, fetchurl, pkgconfig, libestr, json_c, zlib, pythonPackages
, libkrb5 ? null, systemd ? null, jemalloc ? null, libmysql ? null, postgresql ? null
, libdbi ? null, net_snmp ? null, libuuid ? null, curl ? null, gnutls ? null
, libgcrypt ? null, liblognorm ? null, openssl ? null, librelp ? null
, libgt ? null, liblogging ? null, libnet ? null, hadoop ? null, rdkafka ? null
, libmongo-client ? null, czmq ? null, rabbitmq-c ? null, hiredis ? null
}:

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "rsyslog-8.9.0";

  src = fetchurl {
    url = "http://www.rsyslog.com/files/download/rsyslog/${name}.tar.gz";
    sha256 = "1p3saxfs723479rbsdyvqwfrblcp0bw6mkz2ncrxvnccfn70xc7a";
  };

  buildInputs = [
    pkgconfig libestr json_c zlib pythonPackages.docutils
    libkrb5 jemalloc libmysql postgresql libdbi net_snmp libuuid curl gnutls
    libgcrypt liblognorm openssl librelp libgt liblogging libnet hadoop rdkafka
    libmongo-client czmq rabbitmq-c hiredis
  ] ++ stdenv.lib.optional stdenv.isLinux systemd;

  configureFlags = [
    (mkOther                            "sysconfdir"           "/etc")
    (mkOther                            "localstatedir"        "/var")
    (mkWith   true                      "systemdsystemunitdir" "\${out}/etc/systemd/system")
    (mkEnable true                      "largefile"            null)
    (mkEnable true                      "regexp"               null)
    (mkEnable (libkrb5 != null)         "gssapi-krb5"          null)
    (mkEnable true                      "klog"                 null)
    (mkEnable true                      "kmsg"                 null)
    (mkEnable (systemd != null)         "imjournal"            null)
    (mkEnable true                      "inet"                 null)
    (mkEnable (jemalloc != null)        "jemalloc"             null)
    (mkEnable true                      "unlimited-select"     null)
    (mkEnable true                      "usertools"            null)
    (mkEnable (libmysql != null)        "mysql"                null)
    (mkEnable (postgresql != null)      "pgsql"                null)
    (mkEnable (libdbi != null)          "libdbi"               null)
    (mkEnable (net_snmp != null)        "snmp"                 null)
    (mkEnable (libuuid != null)         "uuid"                 null)
    (mkEnable (curl != null)            "elasticsearch"        null)
    (mkEnable (gnutls != null)          "gnutls"               null)
    (mkEnable (libgcrypt != null)       "libgcrypt"            null)
    (mkEnable true                      "rsyslogrt"            null)
    (mkEnable true                      "rsyslogd"             null)
    (mkEnable true                      "mail"                 null)
    (mkEnable (liblognorm != null)      "mmnormalize"          null)
    (mkEnable true                      "mmjsonparse"          null)
    (mkEnable true                      "mmaudit"              null)
    (mkEnable true                      "mmanon"               null)
    (mkEnable true                      "mmutf8fix"            null)
    (mkEnable true                      "mmcount"              null)
    (mkEnable true                      "mmsequence"           null)
    (mkEnable true                      "mmfields"             null)
    (mkEnable true                      "mmpstrucdata"         null)
    (mkEnable (openssl != null)         "mmrfc5424addhmac"     null)
    (mkEnable (librelp != null)         "relp"                 null)
    (mkEnable (libgt != null)           "guardtime"            null)
    (mkEnable (liblogging != null)      "liblogging-stdlog"    null)
    (mkEnable (liblogging != null)      "rfc3195"              null)
    (mkEnable true                      "imfile"               null)
    (mkEnable false                     "imsolaris"            null)
    (mkEnable true                      "imptcp"               null)
    (mkEnable true                      "impstats"             null)
    (mkEnable true                      "omprog"               null)
    (mkEnable (libnet != null)          "omudpspoof"           null)
    (mkEnable true                      "omstdout"             null)
    (mkEnable (systemd != null)         "omjournal"            null)
    (mkEnable true                      "pmlastmsg"            null)
    (mkEnable true                      "pmcisconames"         null)
    (mkEnable true                      "pmciscoios"           null)
    (mkEnable true                      "pmaixforwardedfrom"   null)
    (mkEnable true                      "pmsnare"              null)
    (mkEnable true                      "omruleset"            null)
    (mkEnable true                      "omuxsock"             null)
    (mkEnable true                      "mmsnmptrapd"          null)
    (mkEnable (hadoop != null)          "omhdfs"               null)
    (mkEnable (rdkafka != null)         "omkafka"              null)
    (mkEnable (libmongo-client != null) "ommongodb"            null)
    (mkEnable (czmq != null)            "imzmq3"               null)
    (mkEnable (czmq != null)            "imczmq"               null)
    (mkEnable (czmq != null)            "omzmq3"               null)
    (mkEnable (czmq != null)            "omczmq"               null)
    (mkEnable (rabbitmq-c != null)      "omrabbitmq"           null)
    (mkEnable (hiredis != null)         "omhiredis"            null)
    (mkEnable true                      "generate-man-pages"   null)
  ];

  meta = {
    homepage = "http://www.rsyslog.com/";
    description = "Enhanced syslog implementation";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ wkennington ];
  };
}
