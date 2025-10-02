{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
  kmod,
  kernelModuleMakeFlags,
}:

let
  version = "0.15.1";

in
stdenv.mkDerivation {
  pname = "v4l2loopback";
  version = "${version}-${kernel.version}";

  src = fetchFromGitHub {
    owner = "umlaeute";
    repo = "v4l2loopback";
    tag = "v${version}";
    hash = "sha256-uokj0MB6bw4I8q5dVmSO9XMDvh4T7YODBoCCHvEf4v4=";
  };

  hardeningDisable = [
    "format"
    "pic"
  ];

  preBuild = ''
    substituteInPlace Makefile --replace "modules_install" "INSTALL_MOD_PATH=$out modules_install"
    sed -i '/depmod/d' Makefile
  '';

  # Don't use makeFlags for this
  postBuild = ''
    make utils
  '';

  nativeBuildInputs = [ kmod ] ++ kernel.moduleBuildDependencies;

  postInstall = ''
    make install-utils PREFIX=$bin
  '';

  outputs = [
    "out"
    "bin"
  ];

  makeFlags = kernelModuleMakeFlags ++ [
    "KERNELRELEASE=${kernel.modDirVersion}"
    "KERNEL_DIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "v4l2loopback.ko"
  ];

  meta = {
    description = "Kernel module to create V4L2 loopback devices";
    mainProgram = "v4l2loopback-ctl";
    homepage = "https://github.com/umlaeute/v4l2loopback";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [
      moni
      bot-wxt1221
    ];
    platforms = lib.platforms.linux;
    outputsToInstall = [ "out" ];
  };
}
