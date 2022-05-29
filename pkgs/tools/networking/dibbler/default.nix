{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "dibbler";
  version = "1.0.1";

  src = fetchurl {
    url = "http://www.klub.com.pl/dhcpv6/dibbler/${pname}-${version}.tar.gz";
    sha256 = "18bnwkvax02scjdg5z8gvrkvy1lhssfnlpsaqb5kkh30w1vri1i7";
  };

  configureFlags = [
    "--enable-resolvconf"
  ];

  # -fcommon: Workaround build failure on -fno-common toolchains like upstream
  # gcc-10. Otherwise build fails as:
  #   ld: ./Port-linux/libLowLevel.a(libLowLevel_a-interface.o):(.bss+0x4): multiple definition of `interface_auto_up';
  #     ./Port-linux/libLowLevel.a(libLowLevel_a-lowlevel-linux-link-state.o):(.bss+0x74): first defined here
  NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isDarwin "-D__APPLE_USE_RFC_2292=1" + " -fcommon";

  meta = with lib; {
    description = "Portable DHCPv6 implementation";
    homepage = "https://klub.com.pl/dhcpv6/";
    license = licenses.gpl2Only;
    platforms = platforms.all;
    maintainers = with maintainers; [ fpletz ];
  };
}
