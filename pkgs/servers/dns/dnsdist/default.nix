{ stdenv, fetchurl, pkgconfig, systemd
, boost, libsodium, libedit, re2
, net-snmp, lua, protobuf, openssl, zlib, h2o
}:

stdenv.mkDerivation rec {
  pname = "dnsdist";
  version = "1.4.0";

  src = fetchurl {
    url = "https://downloads.powerdns.com/releases/dnsdist-${version}.tar.bz2";
    sha256 = "1h0x5xd13j8xxrrinb7d55851m6n9w0r15wx9m3c50dk7qngldm3";
  };

  nativeBuildInputs = [ pkgconfig protobuf ];
  buildInputs = [ systemd boost libsodium libedit re2 net-snmp lua openssl zlib h2o ];

  configureFlags = [
    "--enable-libsodium"
    "--enable-re2"
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

  meta = with stdenv.lib; {
    description = "DNS Loadbalancer";
    homepage = "https://dnsdist.org";
    license = licenses.gpl2;
    maintainers = with maintainers; [ das_j ];
  };
}
