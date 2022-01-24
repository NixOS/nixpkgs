{ stdenv, lib, fetchurl, libpcap }:

stdenv.mkDerivation rec {
  pname = "ucarp";
  version = "1.5.2";

  src = fetchurl {
    url = "https://download.pureftpd.org/pub/ucarp/ucarp-${version}.tar.bz2";
    sha256 = "0qidz5sr55nxlmnl8kcbjsrff2j97b44h9l1dmhvvjl46iji7q7j";
  };

  buildInputs = [ libpcap ];

  meta = with lib; {
    description = "Userspace implementation of CARP";
    longDescription = ''
      UCARP allows a couple of hosts to share common virtual IP addresses in
      order to provide automatic failover. It is a portable userland
      implementation of the secure and patent-free Common Address Redundancy
      Protocol (CARP, OpenBSD's alternative to the patents-bloated VRRP).

      Warning: This package has not received any upstream updates for a long
      time and can be considered as unmaintained.
    '';
    license = with licenses; [ isc bsdOriginal bsd2 gpl2Plus ];
    maintainers = with maintainers; [ oxzi ];
  };
}
