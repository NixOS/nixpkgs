{ lib
, stdenv
, fetchFromGitHub
, autoconf-archive
, autoreconfHook
, bison
, flex
, openssl
, libcap
, curl
, which
, eventlog
, pkg-config
, glib
, hiredis
, systemd
, perl
, python3
, riemann_c_client
, protobufc
, pcre
, paho-mqtt-c
, libnet
, json_c
, libuuid
, libivykis
, libxslt
, docbook_xsl
, pcre2
, mongoc
, rabbitmq-c
, libesmtp
, rdkafka
}:
let
  python-deps = ps: with ps; [
    boto3
    botocore
    cachetools
    certifi
    charset-normalizer
    google-auth
    idna
    kubernetes
    oauthlib
    pyasn1
    pyasn1-modules
    python-dateutil
    pyyaml
    requests
    requests-oauthlib
    rsa
    six
    urllib3
    websocket-client
    ply
  ];
  py = python3.withPackages python-deps;
in
stdenv.mkDerivation rec {
  pname = "syslog-ng";
  version = "4.5.0";

  src = fetchFromGitHub {
    owner = "syslog-ng";
    repo = "syslog-ng";
    rev = "syslog-ng-${version}";
    hash = "sha256-cWlTGACuHm8o2563Axh43Ks7EhYok6+V9mOkrYp4km8=";
    fetchSubmodules = true;
  };
  nativeBuildInputs = [ autoreconfHook autoconf-archive pkg-config which bison flex libxslt perl ];

  buildInputs = [
    libcap
    curl
    openssl
    eventlog
    glib
    py
    systemd
    riemann_c_client
    protobufc
    pcre
    libnet
    json_c
    libuuid
    libivykis
    mongoc
    rabbitmq-c
    libesmtp
    pcre2
    paho-mqtt-c
    hiredis
    rdkafka
  ];

  configureFlags = [
    "--enable-manpages"
    "--with-docbook=${docbook_xsl}/xml/xsl/docbook/manpages/docbook.xsl"
    "--enable-dynamic-linking"
    "--enable-systemd"
    "--enable-smtp"
    "--with-python-packages=none"
    "--with-hiredis=system"
    "--with-ivykis=system"
    "--with-librabbitmq-client=system"
    "--with-mongoc=system"
    "--with-jsonc=system"
    "--with-systemd-journal=system"
    "--with-systemdsystemunitdir=$(out)/etc/systemd/system"
    "--without-compile-date"
  ];

  outputs = [ "out" "man" ];

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://www.syslog-ng.com";
    description = "Next-generation syslogd with advanced networking and filtering capabilities";
    license = with licenses; [ gpl2Plus lgpl21Plus ];
    maintainers = with maintainers; [ vifino ];
    platforms = platforms.linux;
  };
}
