{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
  kmod,
  kernelModuleMakeFlags,
<<<<<<< HEAD
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "v4l2loopback";
  version = "0.15.3";
=======
}:

let
  version = "0.15.1";

in
stdenv.mkDerivation {
  pname = "v4l2loopback";
  version = "${version}-${kernel.version}";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "umlaeute";
    repo = "v4l2loopback";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-KXJgsEJJTr4TG4Ww5HlF42v2F1J+AsHwrllUP1n/7g8=";
=======
    hash = "sha256-uokj0MB6bw4I8q5dVmSO9XMDvh4T7YODBoCCHvEf4v4=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  passthru.updateScript = nix-update-script { };

=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
