{ kernel, stdenv, lib, fetchzip, bc }:

stdenv.mkDerivation rec {
  pname = "yt6801";
  version = "1.0.29";

  src = fetchzip {
    url = "https://www.motor-comm.com/Public/Uploads/uploadfile/files/20240812/yt6801-linux-driver-1.0.29.zip";
    sha256 = "sha256-oz6CeOUN6QWKXxe3WUZljhGDTFArsknjzBuQ4IchGeU=";
  };

  hardeningDisable = [ "pic" "format" ];
  KERNELDIR = "${kernel.dev}/lib/modules/${kernel.modDirVersion}";
  nativeBuildInputs = [ bc ] ++ kernel.moduleBuildDependencies;

  configurePhase = "true";

  buildFlags = [ "modules" ];

  makeFlags = [
    "ARCH=${stdenv.hostPlatform.linuxArch}"
    "KSRC_BASE=${KERNELDIR}"
    "KSRC=${KERNELDIR}/build"
    "KDST=kernel/drivers/net/ethernet/motorcomm"
    "INSTALL_MOD_PATH=${placeholder "out"}"
  ] ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "CROSS_COMPILE=${stdenv.cc.targetPrefix}"
  ];

  installPhase = ''
    mkdir -p $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/net/ethernet/motorcomm
    find . -name "*.ko" -exec cp {} $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/net/ethernet/motorcomm/ \;
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Motorcomm yt6801 Network Interface Card driver";
    homepage = "https://www.motor-comm.com/product/ethernet-control-chip";
    license = with licenses; [ gpl2Plus gpl2Only ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ bartvdbraak ];
  };
}
