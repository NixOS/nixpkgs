{
  lib,
  stdenv,
  fetchzip,
  kernel,
  kernelModuleMakeFlags,
}:

stdenv.mkDerivation rec {
  pname = "dpdk-kmods";
  version = "2023-02-05";

  src = fetchzip {
    url = "https://git.dpdk.org/dpdk-kmods/snapshot/dpdk-kmods-e721c733cd24206399bebb8f0751b0387c4c1595.tar.xz";
    sha256 = "sha256-AG5Lthp+CPR4R7I23DUmoWAmET8gLEFHHdjk2TUbQn4=";
  };

  hardeningDisable = [ "pic" ];

  makeFlags = kernelModuleMakeFlags ++ [
    "INSTALL_MOD_PATH=${placeholder "out"}"
  ];
  KSRC = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";

  nativeBuildInputs = kernel.moduleBuildDependencies;

  preBuild = "cd linux/igb_uio";

  installPhase = ''
    make -C ${KSRC} M=$(pwd) modules_install $makeFlags
  '';

  enableParallelBuilding = true;

  meta = {
    description = "Kernel modules for DPDK";
    homepage = "https://git.dpdk.org/dpdk-kmods/";
    license = lib.licenses.gpl2Only;
    maintainers = [ lib.maintainers.mic92 ];
    platforms = lib.platforms.linux;
  };
}
