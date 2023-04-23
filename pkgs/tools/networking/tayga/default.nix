{ lib, stdenv, fetchurl, nixosTests }:

stdenv.mkDerivation rec {
  version = "0.9.2";
  pname = "tayga";

  src = fetchurl {
    url= "http://www.litech.org/${pname}/${pname}-${version}.tar.bz2";
    sha256 = "1700y121lhvpna49bjpssb7jq1abj9qw5wxgjn8gzp6jm4kpj7rb";
  };

  passthru.tests.tayga = nixosTests.tayga;

  meta = with lib; {
    description = "Userland stateless NAT64 daemon";
    longDescription = ''
      TAYGA is an out-of-kernel stateless NAT64 implementation
      for Linux that uses the TUN driver to exchange IPv4 and
      IPv6 packets with the kernel.
      It is intended to provide production-quality NAT64 service
      for networks where dedicated NAT64 hardware would be overkill.
    '';
    homepage = "http://www.litech.org/tayga";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ _0x4A6F ];
    platforms = platforms.linux;
  };
}
