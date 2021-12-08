{ virtualbox, kernel, buildModule }:

buildModule {
  pname = "virtualbox-modules";
  version = "${virtualbox.version}-${kernel.version}";
  src = virtualbox.modsrc;
  hardeningDisable = [
    "fortify" "pic" "stackprotector"
  ];

  # KERN_DIR = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"; TODO(berdario) unused?

  makeFlags = [ "INSTALL_MOD_PATH=$(out)" ];
  installTargets = [ "install" ];

  enableParallelBuilding = true;

  meta = virtualbox.meta // {
    description = virtualbox.meta.description + " (kernel modules)";
  };
}
