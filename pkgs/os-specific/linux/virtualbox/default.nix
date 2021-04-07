{ stdenv, virtualbox, kernel, lib }:

let inherit (lib) optional versionAtLeast;

in stdenv.mkDerivation {
  name = "virtualbox-modules-${virtualbox.version}-${kernel.version}";
  src = virtualbox.modsrc;
  hardeningDisable = [
    "fortify" "pic" "stackprotector"
  ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  KERN_DIR = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";

  makeFlags = [ "INSTALL_MOD_PATH=$(out)" ];
  installTargets = [ "install" ];

  # VirtualBox 6.1.18 doesn't build with linux kernel 5.11.  This fix is based on
  # the discussion at https://forums.virtualbox.org/viewtopic.php?f=7&t=101860
  patches = optional (versionAtLeast kernel.version "5.11" && versionAtLeast "6.1.18" virtualbox.version) [
    ./linux-kernel-5.11.patch
  ];

  enableParallelBuilding = true;

  meta = virtualbox.meta // {
    description = virtualbox.meta.description + " (kernel modules)";
  };
}
