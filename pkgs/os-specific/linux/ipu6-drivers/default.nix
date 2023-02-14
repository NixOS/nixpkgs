{ lib
, stdenv
, fetchFromGitHub
, ivsc-driver
, kernel
}:

stdenv.mkDerivation rec {
  pname = "ipu6-drivers";
  version = "unstable-2023-01-17";

  src = fetchFromGitHub {
    owner = "intel";
    repo = pname;
    rev = "f83b0747b297cc42325668aaf69471d89253b88e";
    hash = "sha256-yl2ZtJUTh1/qmTA8USd+FBCUAY5qNdh4bSvFRPImQNI=";
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
    broken = kernel.kernelOlder "5.15";
  };
}
