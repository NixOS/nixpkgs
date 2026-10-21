{
  kernel,
  kernelModuleMakeFlags,
  kernelModuleInstallHook,
  stdenv,
  basiliskii,
  lib,
}:
stdenv.mkDerivation (finalAttrs: {
  name = "${finalAttrs.pname}-${finalAttrs.version}-${kernel.version}";
  pname = "sheep_net";
  version = basiliskii.version;
  src = basiliskii.src;
  sourceRoot = "${finalAttrs.src.name}/BasiliskII/src/Unix/Linux/NetDriver";

  nativeBuildInputs = kernel.moduleBuildDependencies ++ [ kernelModuleInstallHook ];

  makeFlags = kernelModuleMakeFlags ++ [
    "KERNEL_DIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}"
  ];

  kernelModuleInstallDir = "drivers/net";

  meta = {
    homepage = "https://github.com/kanjitalk755/macemu";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ matthewcroughan ];
    platforms = lib.platforms.linux;
  };
})
