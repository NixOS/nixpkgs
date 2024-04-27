{ lib, stdenv, fetchFromGitHub, kernel, kmod }:

stdenv.mkDerivation {
  pname = "v4l2loopback";
  version = "0.12.7-unstable-2024-02-12-${kernel.version}";

  src = fetchFromGitHub {
    owner = "umlaeute";
    repo = "v4l2loopback";
    rev = "5d72c17f92ee0e38efbb7eb85e34443ecbf1a80c";
    hash = "sha256-ggmYH5MUXhMPvA8UZ2EAG+eGoPTNbw7B8UxmmgP6CsE=";
  };

  hardeningDisable = [ "format" "pic" ];

  preBuild = ''
    substituteInPlace Makefile --replace "modules_install" "INSTALL_MOD_PATH=$out modules_install"
    sed -i '/depmod/d' Makefile
  '';

  nativeBuildInputs = [ kmod ] ++ kernel.moduleBuildDependencies;

  postInstall = ''
    make install-utils PREFIX=$bin
  '';

  outputs = [ "out" "bin" ];

  makeFlags = kernel.makeFlags ++ [
    "KERNELRELEASE=${kernel.modDirVersion}"
    "KERNEL_DIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  meta = with lib; {
    description = "A kernel module to create V4L2 loopback devices";
    mainProgram = "v4l2loopback-ctl";
    homepage = "https://github.com/umlaeute/v4l2loopback";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ moni ];
    platforms = platforms.linux;
    outputsToInstall = [ "out" ];
  };
}
