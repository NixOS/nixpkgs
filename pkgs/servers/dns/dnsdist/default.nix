{ lib, stdenv, fetchurl, pkg-config, systemd
, boost, libsodium, libedit, re2
, net-snmp, lua, protobuf, openssl, zlib, h2o
}:

stdenv.mkDerivation rec {
  pname = "dnsdist";
  version = "1.5.2";

  src = fetchurl {
    url = "https://downloads.powerdns.com/releases/dnsdist-${version}.tar.bz2";
    sha256 = "sha256-K9e1M9Lae7RWY8amLkftDS8Zigd/WNxzDEY7eXNjZ0k=";
  };

  nativeBuildInputs = [ pkg-config protobuf ];
  buildInputs = [ systemd boost libsodium libedit re2 net-snmp lua openssl zlib h2o ];

  configureFlags = [
    "--with-libsodium"
    "--with-re2"
    "--enable-dnscrypt"
    "--enable-dns-over-tls"
    "--enable-dns-over-https"
    "--with-protobuf=yes"
    "--with-net-snmp"
    "--disable-dependency-tracking"
    "--enable-unit-tests"
    "--enable-systemd"
  ];

  doCheck = true;

  enableParallelBuilding = true;

  meta = with lib; {
    description = "DNS Loadbalancer";
    homepage = "https://dnsdist.org";
    license = licenses.gpl2;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
