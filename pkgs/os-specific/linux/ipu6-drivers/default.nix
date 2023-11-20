{ lib
, stdenv
, fetchFromGitHub
, ivsc-driver
, kernel
}:

stdenv.mkDerivation {
  pname = "ipu6-drivers";
  version = "unstable-2023-11-15";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "ipu6-drivers";
    rev = "067270ff020aaec9456085c217f1c2747c8c5ef5";
    hash = "sha256-fK5WTO1wfu3nVBsUfKiAgrxwH9DSaludNLBtMxMhG+A=";
  };

  postPatch = ''
    cp --no-preserve=mode --recursive --verbose \
      ${ivsc-driver.src}/backport-include \
      ${ivsc-driver.src}/drivers \
      ${ivsc-driver.src}/include \
      .
  '';

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
    homepage = "https://github.com/intel/ipu6-drivers";
    description = "IPU6 kernel driver";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ hexa ];
    platforms = [ "x86_64-linux" ];
    # requires 6.1.7 https://github.com/intel/ipu6-drivers/pull/84
    broken = kernel.kernelOlder "6.1.7";
  };
}
