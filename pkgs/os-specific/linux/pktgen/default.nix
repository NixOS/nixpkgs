{ stdenv, lib, fetchurl, pkgconfig
, dpdk, libpcap, lua5_3, numactl, utillinux
, gtk2, which, withGtk ? false
}:

stdenv.mkDerivation rec {
  pname = "pktgen";
  version = "3.7.2";

  src = fetchurl {
    url = "http://dpdk.org/browse/apps/pktgen-dpdk/snapshot/${pname}-${version}.tar.xz";
    sha256 = "03k7h4j2lsrh6b7477hgn87ljrjh2673ncffx9v261bx1ns54y7w";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs =
    [ dpdk libpcap lua5_3 numactl which ]
    ++ stdenv.lib.optionals withGtk [gtk2];

  RTE_SDK = "${dpdk}/share/dpdk";
  RTE_TARGET = "x86_64-native-linuxapp-gcc";
  GUI = stdenv.lib.optionalString withGtk "true";

  NIX_CFLAGS_COMPILE = [ "-msse3" ];

  postPatch = let dpdkMajor = lib.versions.major dpdk.version; in ''
    substituteInPlace lib/common/lscpu.h --replace /usr/bin/lscpu ${utillinux}/bin/lscpu
  '';

  installPhase = ''
    install -d $out/bin
    install -m 0755 app/${RTE_TARGET}/pktgen $out/bin
    install -m 0644 Pktgen.lua $out/bin
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Traffic generator powered by DPDK";
    homepage = http://dpdk.org/;
    license = licenses.bsdOriginal;
    platforms =  [ "x86_64-linux" ];
    maintainers = [ maintainers.abuibrahim ];
  };
}
