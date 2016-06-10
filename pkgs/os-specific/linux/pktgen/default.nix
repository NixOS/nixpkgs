{ stdenv, fetchurl, dpdk, libpcap, utillinux }:

stdenv.mkDerivation rec {
  name = "pktgen-${version}";
  version = "3.0.00";

  src = fetchurl {
    url = "http://dpdk.org/browse/apps/pktgen-dpdk/snapshot/pktgen-${version}.tar.gz";
    sha256 = "703f8bd615aa4ae3a3085055483f9889dda09d082abb58afd33c1ba7c766ea65";
  };

  buildInputs = [ dpdk libpcap ];

  RTE_SDK = "${dpdk}";
  RTE_TARGET = "x86_64-native-linuxapp-gcc";

  enableParallelBuilding = true;

  NIX_CFLAGS_COMPILE = [ "-march=core2" ];

  patchPhase = ''
    sed -i -e s:/usr/local:$out:g lib/lua/src/luaconf.h
    sed -i -e s:/usr/bin/lscpu:${utillinux}/bin/lscpu:g lib/common/wr_lscpu.h
  '';

  installPhase = ''
    install -d $out/bin
    install -m 0755 app/app/${RTE_TARGET}/app/pktgen $out/bin
    install -d $out/lib/lua/5.3
    install -m 0644 Pktgen.lua $out/lib/lua/5.3
  '';

  meta = with stdenv.lib; {
    description = "Traffic generator powered by DPDK";
    homepage = http://dpdk.org/;
    license = licenses.bsdOriginal;
    platforms =  [ "x86_64-linux" ];
    maintainers = [ maintainers.abuibrahim ];
  };
}
