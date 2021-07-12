{ lib, stdenv, fetchurl, pkg-config, systemd
, boost, libsodium, libedit, re2
, net-snmp, lua, protobuf, openssl, zlib, h2o
, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "dnsdist";
  version = "1.6.0";

  src = fetchurl {
    url = "https://downloads.powerdns.com/releases/dnsdist-${version}.tar.bz2";
    sha256 = "sha256-p3g6BNjUrSsBaP+q+F75XV9VcFewRiKAaE3XmdDN0pI=";
  };

  patches = [
    # Disable tests requiring networking:
    # "Error connecting to new server with address 192.0.2.1:53: connecting socket to 192.0.2.1:53: Network is unreachable"
    ./disable-network-tests.patch
  ];

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

  passthru.tests = {
    inherit (nixosTests) dnsdist;
  };

  meta = with lib; {
    description = "DNS Loadbalancer";
    homepage = "https://dnsdist.org";
    license = licenses.gpl2;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
