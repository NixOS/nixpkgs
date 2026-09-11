{
  stdenv,
  virtualbox,
  kernel,
  kernelModuleMakeFlags,
}:

stdenv.mkDerivation {
  pname = "virtualbox-modules";
  version = "${virtualbox.version}-${kernel.version}";
  src = virtualbox.modsrc;
  hardeningDisable = [
    "fortify"
    "pic"
    "stackprotector"
  ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  env.KERN_DIR = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";

  makeFlags = kernelModuleMakeFlags ++ [
    "INSTALL_MOD_PATH=$(out)"
    "VBOX_ALLOW_MODULE_SIGNING=1"
  ];
  installTargets = [ "install" ];

  enableParallelBuilding = true;

  meta = virtualbox.meta // {
    description = virtualbox.meta.description + " (kernel modules)";
  };
}
