{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  ivsc-driver,
  kernel,
  kernelModuleMakeFlags,
}:

stdenv.mkDerivation {
  pname = "ipu7-drivers";
  version = "unstable-2025-11-12";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "ipu7-drivers";
    rev = "fc335577f95bf6ca3afc706d1ceab8297db4f010";
    hash = "sha256-tRljxzo/WsFBLi/1YqxVRtXpSZzHRqIy3RZ8/heu7mI=";
  };

  patches = [
    ./0001-media-ipu7-Stop-accessing-streams-configs-directly.patch
  ];

  postPatch = ''
    cp --no-preserve=mode --recursive --verbose \
      ${ivsc-driver.src}/backport-include \
      ${ivsc-driver.src}/drivers \
      ${ivsc-driver.src}/include \
      .
  '';

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = kernelModuleMakeFlags ++ [
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
    homepage = "https://github.com/intel/ipu7-drivers";
    description = "IPU7 kernel driver";
    license = lib.licenses.gpl2Only;
    maintainers = [ lib.maintainers.pseudocc ];
    platforms = [ "x86_64-linux" ];
    broken = kernel.kernelOlder "6.12";
  };
}
