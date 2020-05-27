{ stdenv, fetchurl, openssl, libcap, curl, which
, eventlog, pkgconfig, glib, python, systemd, perl
, riemann_c_client, protobufc, pcre, libnet
, json_c, libuuid, libivykis, mongoc, rabbitmq-c
, libesmtp
}:

stdenv.mkDerivation rec {
  pname = "syslog-ng";
  version = "3.27.1";

  src = fetchurl {
    url = "https://github.com/${pname}/${pname}/releases/download/${pname}-${version}/${pname}-${version}.tar.gz";
    sha256 = "1cv1kn4jpqyhlhx8w5v557jyc4b2ly2dgkv1hbb8vzgpjwy66k65";
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
    homepage = "https://www.syslog-ng.com";
    description = "Next-generation syslogd with advanced networking and filtering capabilities";
    license = licenses.gpl2;
    maintainers = with maintainers; [ fpletz ];
    platforms = platforms.linux;
  };
}
