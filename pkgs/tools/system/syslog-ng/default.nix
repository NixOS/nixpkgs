{ lib, stdenv, fetchurl, openssl, libcap, curl, which
, eventlog, pkg-config, glib, python3, systemd, perl
, riemann_c_client, protobufc, pcre, libnet
, json_c, libuuid, libivykis, mongoc, rabbitmq-c
, libesmtp
}:

stdenv.mkDerivation rec {
  pname = "syslog-ng";
  version = "3.38.1";

  src = fetchurl {
    url = "https://github.com/${pname}/${pname}/releases/download/${pname}-${version}/${pname}-${version}.tar.gz";
    sha256 = "sha256-VJH2htC4KbabLg/A1mpi9RmRqvruAFR1v6OPqzmUQfc=";
  };

  nativeBuildInputs = [ pkg-config which ];

  buildInputs = [
    libcap
    curl
    openssl
    eventlog
    glib
    perl
    python3
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
  ];

  configureFlags = [
    "--enable-manpages"
    "--enable-dynamic-linking"
    "--enable-systemd"
    "--enable-smtp"
    "--with-ivykis=system"
    "--with-librabbitmq-client=system"
    "--with-mongoc=system"
    "--with-jsonc=system"
    "--with-systemd-journal=system"
    "--with-systemdsystemunitdir=$(out)/etc/systemd/system"
  ];

  outputs = [ "out" "man" ];

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://www.syslog-ng.com";
    description = "Next-generation syslogd with advanced networking and filtering capabilities";
    license = with licenses; [ gpl2Plus lgpl21Plus ];
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
