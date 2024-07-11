{ stdenv, virtualbox, kernel }:

stdenv.mkDerivation {
  pname = "virtualbox-modules";
  version = "${virtualbox.version}-${kernel.version}";
  src = virtualbox.modsrc;
  hardeningDisable = [
    "fortify" "pic" "stackprotector"
  ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  KERN_DIR = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";

  makeFlags = [ "INSTALL_MOD_PATH=$(out)" ];
  installTargets = [ "install" ];

  enableParallelBuilding = true;

  meta = virtualbox.meta // {
    description = virtualbox.meta.description + " (kernel modules)";
  };
}
