{ stdenv, fetchurl, pkgconfig, systemd
, boost, libsodium, libedit, re2
, net_snmp, lua, protobuf, openssl }: stdenv.mkDerivation rec {
  name = "dnsdist-${version}";
  version = "1.3.2";

  src = fetchurl {
    url = "https://downloads.powerdns.com/releases/dnsdist-${version}.tar.bz2";
    sha256 = "1i3b1vpk9a8zbx9aby2s1ckkzhlvzgn11hcgj3b8x2j1b9771rqb";
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
    homepage = https://dnsdist.org;
    license = licenses.gpl2;
    maintainers = with maintainers; [ das_j ];
  };
}
