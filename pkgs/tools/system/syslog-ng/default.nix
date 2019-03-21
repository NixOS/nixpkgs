{ stdenv, fetchurl, openssl, libcap, curl, which
, eventlog, pkgconfig, glib, python, systemd, perl
, riemann_c_client, protobufc, pcre, libnet
, json_c, libuuid, libivykis, mongoc, rabbitmq-c
, libesmtp
}:

let
  pname = "syslog-ng";
in

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  version = "3.19.1";

  src = fetchurl {
    url = "https://github.com/balabit/${pname}/releases/download/${name}/${name}.tar.gz";
    sha256 = "0y2ixmbl4af4yf0a56pmg1c00nh0yvlfwr9ck9nhxbdysylk3yaw";
  };

  nativeBuildInputs = [ pkgconfig which ];

  buildInputs = [
    libcap
    curl
    openssl
    eventlog
    glib
    perl
    python
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

  meta = with stdenv.lib; {
    homepage = https://www.balabit.com/network-security/syslog-ng/;
    description = "Next-generation syslogd with advanced networking and filtering capabilities";
    license = licenses.gpl2;
    maintainers = with maintainers; [ rickynils  fpletz ];
    platforms = platforms.linux;
  };
}
