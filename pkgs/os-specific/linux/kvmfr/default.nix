{
  lib,
  stdenv,
  kernel,
  kernelModuleMakeFlags,
  kernelModuleInstallHook,
  looking-glass-client,
}:

stdenv.mkDerivation {
  pname = "kvmfr";
  version = looking-glass-client.version;

  src = looking-glass-client.src;
  sourceRoot = "${looking-glass-client.src.name}/module";
  hardeningDisable = [
    "pic"
    "format"
  ];
  nativeBuildInputs = kernel.moduleBuildDependencies ++ [ kernelModuleInstallHook ];

  makeFlags = kernelModuleMakeFlags ++ [
    "KVER=${kernel.modDirVersion}"
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  kernelModuleInstallDir = "kernel/drivers/misc";

  meta = {
    description = "Optional kernel module for LookingGlass";
    longDescription = ''
      This kernel module implements a basic interface to the IVSHMEM device for LookingGlass when using LookingGlass in VM->VM mode
      Additionally, in VM->host mode, it can be used to generate a shared memory device on the host machine that supports dmabuf
    '';
    homepage = "https://github.com/gnif/LookingGlass";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ j-brn ];
    platforms = [ "x86_64-linux" ];
    broken = kernel.kernelOlder "5.3";
  };
}
