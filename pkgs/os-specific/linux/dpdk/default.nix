{ stdenv, lib, kernel, fetchurl, pkgconfig, numactl }:

let

  kver = kernel.modDirVersion or null;

  mod = kernel != null;

in stdenv.mkDerivation rec {
  name = "dpdk-${version}" + lib.optionalString mod "-${kernel.version}";
  version = "17.11.2";

  src = fetchurl {
    url = "http://fast.dpdk.org/rel/dpdk-${version}.tar.xz";
    sha256 = "19m5l3jkrns8r1zbjb6ry18w50ff36kbl5b5g6pfcp9p57sfisd2";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ numactl ] ++ lib.optional mod kernel.moduleBuildDependencies;

  RTE_KERNELDIR = if mod then "${kernel.dev}/lib/modules/${kver}/build" else "/var/empty";
  RTE_TARGET = "x86_64-native-linuxapp-gcc";

  # we need sse3 instructions to build
  NIX_CFLAGS_COMPILE = [ "-msse3" ];
  hardeningDisable = [ "pic" ];

  postPatch = lib.optionalString (!mod) ''
    # Do not build kernel modules.
    cat >>config/defconfig_$RTE_TARGET <<EOF
CONFIG_RTE_EAL_IGB_UIO=n
CONFIG_RTE_KNI_KMOD=n
EOF
  '';

  configurePhase = ''
    make T=${RTE_TARGET} config
  '';

  installTargets = [ "install-runtime" "install-sdk" "install-kmod" ]; # skip install-doc

  installFlags = [
    "prefix=$(out)" "datadir=$(out)" "includedir=$(out)/include"
  ] ++ lib.optionals mod [
    "kerneldir=$(kmod)/lib/modules/${kver}"
  ];

  outputs = [ "out" ] ++ lib.optional mod "kmod";

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Set of libraries and drivers for fast packet processing";
    homepage = http://dpdk.org/;
    license = with licenses; [ lgpl21 gpl2 bsd2 ];
    platforms =  [ "x86_64-linux" ];
    maintainers = with maintainers; [ domenkozar orivej ];
  };
}
