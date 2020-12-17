{ stdenv, fetchurl, pkgconfig, systemd
, boost, libsodium, libedit, re2
, net-snmp, lua, protobuf, openssl, zlib, h2o
}:

stdenv.mkDerivation rec {
  pname = "dnsdist";
  version = "1.5.1";

  src = fetchurl {
    url = "https://downloads.powerdns.com/releases/dnsdist-${version}.tar.bz2";
    sha256 = "1wgv19b6y4fp5x1z54psaaialji2rckl5vdh156kyw47k9r5krya";
  };

  nativeBuildInputs = [ pkgconfig protobuf ];
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

  meta = with stdenv.lib; {
    description = "DNS Loadbalancer";
    homepage = "https://dnsdist.org";
    license = licenses.gpl2;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
