{
  stdenv,
  lib,
  fetchurl,
  kernel,
  kernelModuleMakeFlags,
  nixosTests,
  flex,
  coccinelle,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "drbd";
  version = "9.2.16";

  src = fetchurl {
    url = "https://pkg.linbit.com//downloads/drbd/9/drbd-${finalAttrs.version}.tar.gz";
    hash = "sha256-2ff9XtSlUnJG5y6qrRYGTgQiZdEnzywKaKR96ItF8Zw=";
  };

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = [
    kernel.moduleBuildDependencies
    flex
    coccinelle
    python3
  ];

  enableParallelBuilding = true;

  makeFlags = kernelModuleMakeFlags ++ [
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "KVER=${kernel.version}"
    "INSTALL_MOD_PATH=${placeholder "out"}"
    "M=$(sourceRoot)"
    "SPAAS=false"
  ];

  installFlags = [ "INSTALL_MOD_PATH=${placeholder "out"}" ];

  postPatch = ''
    patchShebangs .
    substituteInPlace Makefile --replace 'SHELL=/bin/bash' 'SHELL=${builtins.getEnv "SHELL"}'
  '';

  passthru.tests.drbd-driver = nixosTests.drbd-driver;

  meta = {
    homepage = "https://github.com/LINBIT/drbd";
    description = "LINBIT DRBD kernel module";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ birkb ];
    longDescription = ''
      DRBD is a software-based, shared-nothing, replicated storage solution
      mirroring the content of block devices (hard disks, partitions, logical volumes, and so on) between hosts.
    '';
    broken = kernel.kernelOlder "5.11";
  };
})
