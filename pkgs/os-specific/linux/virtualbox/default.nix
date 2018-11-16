{ stdenv, virtualbox, kernel }:

stdenv.mkDerivation {
  name = "virtualbox-modules-${virtualbox.version}-${kernel.version}";
  src = virtualbox.modsrc;
  hardeningDisable = [
    "fortify" "pic" "stackprotector"
  ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  patches = [
    ./fix_kerndir.patch
    ./fix_kbuild.patch
  ];

  KERN_DIR = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";
  INCLUDE_BASE = "${virtualbox.modsrc}";

  makeFlags = [
    "-C ${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "INSTALL_MOD_PATH=$(out)"
  ];
  preBuild = "makeFlagsArray+=(\"M=$(pwd)\")";
  buildFlags = [ "modules" ];
  installTargets = [ "modules_install" ];

  enableParallelBuilding = true;

  meta = virtualbox.meta // {
    description = virtualbox.meta.description + " (kernel modules)";
  };
}
