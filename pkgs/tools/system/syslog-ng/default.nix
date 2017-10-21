{ stdenv, fetchurl, openssl, libcap, curl, which
, eventlog, pkgconfig, glib, python, systemd, perl
, riemann_c_client, protobufc, pcre, libnet
, json_c, libuuid, libivykis, mongoc, rabbitmq-c }:

let
  pname = "syslog-ng";
in

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  version = "3.11.1";

  src = fetchurl {
    url = "https://github.com/balabit/${pname}/releases/download/${name}/${name}.tar.gz";
    sha256 = "1sa51bh3rs4gq4zpgkyv94lqcx3qvxa41d2dsa7hyxidkp1rs2b4";
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
  ];

  configureFlags = [
    "--enable-manpages"
    "--enable-dynamic-linking"
    "--enable-systemd"
    "--with-ivykis=system"
    "--with-librabbitmq-client=system"
    "--with-mongoc=system"
    "--with-jsonc=system"
    "--with-systemd-journal=system"
    "--with-systemdsystemunitdir=$(out)/etc/systemd/system"
  ];

  outputs = [ "out" "man" ];

  meta = with stdenv.lib; {
    homepage = http://www.balabit.com/network-security/syslog-ng/;
    description = "Next-generation syslogd with advanced networking and filtering capabilities";
    license = licenses.gpl2;
    maintainers = with maintainers; [ rickynils  fpletz ];
    platforms = platforms.linux;
  };
}
