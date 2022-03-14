{ lib, stdenv, fetchzip, kernel }:

stdenv.mkDerivation rec {
  pname = "dpdk-kmods";
  version = "2021-04-21";

  src = fetchzip {
    url = "http://git.dpdk.org/dpdk-kmods/snapshot/dpdk-kmods-e13d7af77a1bf98757f85c3c4083f6ee6d0d2372.tar.xz";
    sha256 = "sha256-8ysWT3X3rIyUAo4/QbkX7cQq5iFeU18/BPsmmWugcIc=";
  };

  hardeningDisable = [ "pic" ];

  makeFlags = kernel.makeFlags ++ [
    "INSTALL_MOD_PATH=${placeholder "out"}"
  ];
  KSRC = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";

  nativeBuildInputs = kernel.moduleBuildDependencies;

  preBuild = "cd linux/igb_uio";

  installPhase = ''
    make -C ${KSRC} M=$(pwd) modules_install $makeFlags
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Kernel modules for DPDK";
    homepage = "https://git.dpdk.org/dpdk-kmods/";
    license = licenses.gpl2Only;
    maintainers = [ maintainers.mic92 ];
    platforms = platforms.linux;
  };
}
