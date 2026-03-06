{
  stdenv,
  virtualbox,
  kernel,
  fetchpatch,
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

  patches = [
    (fetchpatch {
      url = "https://raw.githubusercontent.com/rpmfusion/VirtualBox-kmod/ec4795b376212b9361c2554c249886c62008c3f8/kernel-6.19.patch";
      sha256 = "sha256-HhJ/2dnJQIXGv86Avlb42+gRzAgNx3eq81gfDwmqjeU=";
      excludes = [
        "vboxsf/**/*"
        "vboxguest/**/*"
      ];
    })
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
