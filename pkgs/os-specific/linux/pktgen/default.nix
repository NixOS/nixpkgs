{ stdenv, fetchurl, dpdk, libpcap, utillinux
, pkgconfig
, gtk2, withGtk ? false
}:

stdenv.mkDerivation rec {
  name = "pktgen-${version}";
  version = "3.1.0";

  src = fetchurl {
    url = "http://dpdk.org/browse/apps/pktgen-dpdk/snapshot/pktgen-v${version}.tar.gz";
    sha256 = "1a1dl8h8p76wlcjlvn736mz4nc2nc5c3764rlydiz86wl45mb0nb";
  };

  nativeBuildInputs = stdenv.lib.optionals withGtk [ pkgconfig ];

  buildInputs =
    [ dpdk libpcap ]
    ++ stdenv.lib.optionals withGtk [gtk2];

  RTE_SDK = "${dpdk}";
  RTE_TARGET = "x86_64-native-linuxapp-gcc";
  GUI = stdenv.lib.optionalString withGtk "true";

  NIX_CFLAGS_COMPILE = [ "-march=core2" ];

  postPatch = ''
    substituteInPlace lib/lua/src/luaconf.h --replace /usr/local $out
    substituteInPlace lib/common/lscpu.h --replace /usr/bin/lscpu ${utillinux}/bin/lscpu
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
