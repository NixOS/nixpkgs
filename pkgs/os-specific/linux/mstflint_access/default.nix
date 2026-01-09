{
  lib,
  stdenv,
  fetchurl,
  kernel,
  kmod,
  mstflint,
  kernelModuleMakeFlags,
}:

stdenv.mkDerivation rec {
  pname = "mstflint_access";
  inherit (mstflint) version src;

  sourceRoot = "source/kernel";

  nativeBuildInputs = [ kmod ] ++ kernel.moduleBuildDependencies;

  makeFlags = kernelModuleMakeFlags ++ [
    "KVER=${kernel.modDirVersion}"
    "KSRC=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  enableParallelBuilding = true;

  installTargets = [ "modules_install" ];
  installFlags = [
    "-C"
    "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "INSTALL_MOD_PATH=${placeholder "out"}"
    "M=$(PWD)"
  ]
  ++ makeFlags;

  meta = {
    description = "Kernel module for Nvidia NIC firmware update";
    homepage = "https://github.com/Mellanox/mstflint";
    license = [ lib.licenses.gpl2Only ];
    maintainers = with lib.maintainers; [ thillux ];
    platforms = lib.platforms.linux;
  };
}
