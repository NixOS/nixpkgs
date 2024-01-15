{ lib, stdenv, fetchFromGitHub, kernel, kmod }:

stdenv.mkDerivation {
  pname = "v4l2loopback";
  version = "unstable-2023-11-23-${kernel.version}";

  src = fetchFromGitHub {
    owner = "umlaeute";
    repo = "v4l2loopback";
    rev = "850a2e36849f6ad3c9bf74f2ae3f603452bd8a71";
    hash = "sha256-LqP5R3oKbjUQUfDZUWpkrmyopWhOt4wlgSgGywTPJXM=";
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
    homepage = "https://github.com/umlaeute/v4l2loopback";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ moni ];
    platforms = platforms.linux;
    outputsToInstall = [ "out" ];
  };
}
