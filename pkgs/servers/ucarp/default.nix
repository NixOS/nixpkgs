{
  stdenv,
  lib,
  fetchurl,
  libpcap,
}:

stdenv.mkDerivation rec {
  pname = "ucarp";
  version = "1.5.2";

  src = fetchurl {
    url = "https://download.pureftpd.org/pub/ucarp/ucarp-${version}.tar.bz2";
    sha256 = "0qidz5sr55nxlmnl8kcbjsrff2j97b44h9l1dmhvvjl46iji7q7j";
  };

  buildInputs = [ libpcap ];

  # Workaround build failure on -fno-common toolchains like upstream
  # gcc-10. Otherwise build fails as:
  #   ld: daemonize.o:/build/ucarp-1.5.2/src/ip_carp.h:73: multiple definition of
  #     `__packed'; ucarp.o:/build/ucarp-1.5.2/src/ip_carp.h:73: first defined here
  env.NIX_CFLAGS_COMPILE = "-fcommon";

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
    license = with licenses; [
      isc
      bsdOriginal
      bsd2
      gpl2Plus
    ];
    maintainers = with maintainers; [ oxzi ];
    mainProgram = "ucarp";
  };
}
