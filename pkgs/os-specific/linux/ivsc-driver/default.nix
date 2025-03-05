{ lib
, stdenv
, fetchFromGitHub
, kernel
}:

stdenv.mkDerivation {
  pname = "ivsc-driver";
  version = "unstable-2024-09-18";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "ivsc-driver";
    rev = "10f440febe87419d5c82d8fe48580319ea135b54";
    hash = "sha256-jc+8geVquRtaZeIOtadCjY9F162Rb05ptE7dk8kuof0=";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = kernel.makeFlags ++ [
    "KERNELRELEASE=${kernel.modDirVersion}"
    "KERNEL_SRC=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  enableParallelBuilding = true;

  preInstall = ''
    sed -i -e "s,INSTALL_MOD_DIR=,INSTALL_MOD_PATH=$out INSTALL_MOD_DIR=," Makefile
  '';

  installTargets = [
    "modules_install"
  ];

  meta = {
    homepage = "https://github.com/intel/ivsc-driver";
    description = "Intel Vision Sensing Controller kernel driver";
    license = lib.licenses.gpl2Only;
    maintainers = [ ];
    platforms = [ "x86_64-linux" ];
    # This module is in mainline now and upstream suggests using that
    # with recent kernels rather than the out-of-tree module.
    broken = kernel.kernelOlder "5.15" || kernel.kernelAtLeast "6.9";
  };
}
