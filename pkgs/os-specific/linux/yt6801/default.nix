{
  kernel,
  stdenv,
  lib,
  fetchzip,
}:

stdenv.mkDerivation {
  pname = "yt6801";
  version = "1.0.29";

  src = fetchzip {
    url = "https://www.motor-comm.com/Public/Uploads/uploadfile/files/20240812/yt6801-linux-driver-1.0.29.zip";
    sha256 = "sha256-oz6CeOUN6QWKXxe3WUZljhGDTFArsknjzBuQ4IchGeU=";
    stripRoot = false;
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;

  preConfigure = "cd src";

  configurePhase = "true";

  buildFlags = [ "modules" ];

  makeFlags =
    [
      "ARCH=${stdenv.hostPlatform.linuxArch}"
      "KSRC=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    ]
    ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
      "CROSS_COMPILE=${stdenv.cc.targetPrefix}"
    ];

  installPhase = ''
    mkdir -p $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/net/ethernet/motorcomm
    cp src/yt6801.ko $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/net/ethernet/motorcomm/
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Motorcomm yt6801 Network Interface Card driver";
    homepage = "https://www.motor-comm.com/product/ethernet-control-chip";
    license = with licenses; [
      gpl2Plus
      gpl2Only
    ];
    platforms = platforms.linux;
  };
}
