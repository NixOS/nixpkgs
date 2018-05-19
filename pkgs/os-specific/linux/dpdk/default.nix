{ stdenv, kernel, fetchurl, pkgconfig, numactl }:

stdenv.mkDerivation rec {
  name = "dpdk-${version}-${kernel.version}";
  version = "17.11.2";

  src = fetchurl {
    url = "http://fast.dpdk.org/rel/dpdk-${version}.tar.xz";
    sha256 = "19m5l3jkrns8r1zbjb6ry18w50ff36kbl5b5g6pfcp9p57sfisd2";
  };

  nativeBuildInputs = [ pkgconfig ] ++ kernel.moduleBuildDependencies;
  buildInputs = [ numactl ];

  RTE_KERNELDIR = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";
  RTE_TARGET = "x86_64-native-linuxapp-gcc";

  # we need sse3 instructions to build
  NIX_CFLAGS_COMPILE = [ "-msse3" ];

  enableParallelBuilding = true;
  outputs = [ "out" "kmod" ];

  hardeningDisable = [ "pic" ];

  configurePhase = ''
    make T=${RTE_TARGET} config
  '';

  installPhase = ''
    make install-runtime DESTDIR=$out prefix= includedir=/include datadir=/
    make install-sdk DESTDIR=$out prefix= includedir=/include datadir=/
    make install-kmod DESTDIR=$kmod
  '';

  meta = with stdenv.lib; {
    description = "Set of libraries and drivers for fast packet processing";
    homepage = http://dpdk.org/;
    license = with licenses; [ lgpl21 gpl2 bsd2 ];
    platforms =  [ "x86_64-linux" ];
    maintainers = [ maintainers.domenkozar ];
  };
}
