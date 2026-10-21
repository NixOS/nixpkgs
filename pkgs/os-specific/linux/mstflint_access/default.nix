{
  lib,
  stdenv,
  fetchurl,
  kernel,
  kmod,
  mstflint,
  kernelModuleMakeFlags,
  kernelModuleInstallHook,
}:

stdenv.mkDerivation {
  pname = "mstflint_access";
  inherit (mstflint) version src;

  sourceRoot = "source/kernel";

  nativeBuildInputs = kernel.moduleBuildDependencies ++ [
    kernelModuleInstallHook
    kmod
  ];

  makeFlags = kernelModuleMakeFlags ++ [
    "KVER=${kernel.modDirVersion}"
    "KSRC=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  enableParallelBuilding = true;

  meta = {
    description = "Kernel module for Nvidia NIC firmware update";
    homepage = "https://github.com/Mellanox/mstflint";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ thillux ];
    platforms = lib.platforms.linux;
  };
}
