{ stdenv, lib, kernel, fetchurl, libvirt }:

assert lib.versionAtLeast kernel.version "3.18";

stdenv.mkDerivation rec {
  name = "dpdk-${version}-${kernel.version}";
  version = "16.04";

  src = fetchurl {
    url = "http://dpdk.org/browse/dpdk/snapshot/dpdk-${version}.tar.gz";
    sha256 = "0yrz3nnhv65v2jzz726bjswkn8ffqc1sr699qypc9m78qrdljcfn";
  };

  buildInputs = [ libvirt ];

  RTE_KERNELDIR = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";
  RTE_TARGET = "x86_64-native-linuxapp-gcc";

  enableParallelBuilding = true;
  outputs = [ "out" "examples" ];

  # we need ssse3 instructions to build
  NIX_CFLAGS_COMPILE = [ "-march=core2" ];

  patchPhase = ''
    sed -i 's/CONFIG_RTE_BUILD_COMBINE_LIBS=n/CONFIG_RTE_BUILD_COMBINE_LIBS=y/' config/common_linuxapp
  '';

  buildPhase = ''
    make T=x86_64-native-linuxapp-gcc -j$NIX_BUILD_CORES -l$NIX_BUILD_CORES config
    make T=x86_64-native-linuxapp-gcc -j$NIX_BUILD_CORES -l$NIX_BUILD_CORES install
    make T=x86_64-native-linuxapp-gcc -j$NIX_BUILD_CORES -l$NIX_BUILD_CORES examples
  '';

  installPhase = ''
    mkdir $out
    cp -pr x86_64-native-linuxapp-gcc/{app,lib,include,kmod} $out/

    mkdir $examples
    cp -pr examples/* $examples/
  '';

  meta = with stdenv.lib; {
    description = "Set of libraries and drivers for fast packet processing";
    homepage = http://dpdk.org/;
    license = with licenses; [ lgpl21 gpl2 bsd2 ];
    platforms =  [ "x86_64-linux" ];
    maintainers = [ maintainers.iElectric ];
  };
}
