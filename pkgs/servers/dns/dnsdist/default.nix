{ stdenv, fetchurl, pkgconfig, systemd
, boost, libsodium, libedit, re2
, net_snmp, lua, protobuf, openssl }: stdenv.mkDerivation rec {
  name = "dnsdist-${version}";
  version = "1.3.0";

  src = fetchurl {
    url = "https://downloads.powerdns.com/releases/dnsdist-${version}.tar.bz2";
    sha256 = "025sgvpi3ps0n4mzfwkk6a5ang90a3c7s2fi9vni6jj0p16wsrxa";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ systemd boost libsodium libedit re2 net_snmp lua protobuf openssl ];

  configureFlags = [
    "--enable-libsodium"
    "--enable-re2"
    "--enable-dnscrypt"
    "--enable-dns-over-tls"
    "--with-protobuf=yes"
    "--with-net-snmp"
    "--disable-dependency-tracking"
    "--enable-unit-tests"
    "--enable-systemd"
  ];

  doCheck = true;

  meta = with stdenv.lib; {
    description = "DNS Loadbalancer";
    homepage = "https://dnsdist.org";
    license = licenses.gpl2;
    maintainers = with maintainers; [ das_j ];
  };
}
