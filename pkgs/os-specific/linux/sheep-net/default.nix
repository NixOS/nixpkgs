{
  kernel,
  kernelModuleMakeFlags,
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

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = kernelModuleMakeFlags ++ [
    "KERNEL_DIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}"
    "INSTALL_MOD_PATH=${placeholder "out"}"
    "INSTALL_MOD_DIR=drivers/net"
    "DEPMOD=true"
  ];

  installTargets = [ "modules_install" ];

  installFlags = [
    "-C"
    "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "M=$(PWD)"
  ];

  meta = {
    homepage = "https://github.com/kanjitalk755/macemu";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ matthewcroughan ];
    platforms = lib.platforms.linux;
  };
})
