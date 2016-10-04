{ stdenv, lib, kernel, fetchurl, pkgconfig, libvirt }:

assert lib.versionAtLeast kernel.version "3.18";

stdenv.mkDerivation rec {
  name = "dpdk-${version}-${kernel.version}";
  version = "16.07";

  src = fetchurl {
    url = "http://dpdk.org/browse/dpdk/snapshot/dpdk-${version}.tar.gz";
    sha256 = "1sgh55w3xpc0lb70s74cbyryxdjijk1fbv9b25jy8ms3lxaj966c";
  };

  buildInputs = [ pkgconfig libvirt ];

  RTE_KERNELDIR = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";
  RTE_TARGET = "x86_64-native-linuxapp-gcc";

  # we need sse3 instructions to build
  NIX_CFLAGS_COMPILE = [ "-march=core2" ];

  enableParallelBuilding = true;
  outputs = [ "out" "kmod" "examples" ];

  hardeningDisable = [ "pic" ];

  configurePhase = ''
    make T=x86_64-native-linuxapp-gcc config
  '';

  buildPhase = ''
    make T=x86_64-native-linuxapp-gcc install
    make T=x86_64-native-linuxapp-gcc examples
  '';

  installPhase = ''
    install -m 0755 -d $out/lib
    install -m 0644 ${RTE_TARGET}/lib/*.a $out/lib

    install -m 0755 -d $out/include
    install -m 0644 ${RTE_TARGET}/include/*.h $out/include

    install -m 0755 -d $out/include/generic
    install -m 0644 ${RTE_TARGET}/include/generic/*.h $out/include/generic

    install -m 0755 -d $out/include/exec-env
    install -m 0644 ${RTE_TARGET}/include/exec-env/*.h $out/include/exec-env

    install -m 0755 -d $out/${RTE_TARGET}
    install -m 0644 ${RTE_TARGET}/.config $out/${RTE_TARGET}

    install -m 0755 -d $out/${RTE_TARGET}/include
    install -m 0644 ${RTE_TARGET}/include/rte_config.h $out/${RTE_TARGET}/include

    cp -pr mk scripts $out/

    mkdir -p $kmod/lib/modules/${kernel.modDirVersion}/kernel/drivers/net
    cp ${RTE_TARGET}/kmod/*.ko $kmod/lib/modules/${kernel.modDirVersion}/kernel/drivers/net

    mkdir -p $examples/bin
    find examples ${RTE_TARGET}/app -type f -executable -exec cp {} $examples/bin \;
  '';

  meta = with stdenv.lib; {
    description = "Set of libraries and drivers for fast packet processing";
    homepage = http://dpdk.org/;
    license = with licenses; [ lgpl21 gpl2 bsd2 ];
    platforms =  [ "x86_64-linux" ];
    maintainers = [ maintainers.domenkozar ];
  };
}
