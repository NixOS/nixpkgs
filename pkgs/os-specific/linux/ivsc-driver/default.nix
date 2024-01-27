{ lib
, stdenv
, fetchFromGitHub
, kernel
}:

stdenv.mkDerivation {
  pname = "ivsc-driver";
  version = "unstable-2023-11-09";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "ivsc-driver";
    rev = "73a044d9633212fac54ea96cdd882ff5ab40573e";
    hash = "sha256-vE5pOtVqjiWovlUMSEoBKTk/qvs8K8T5oY2r7njh0wQ=";
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
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ hexa ];
    platforms = [ "x86_64-linux" ];
    broken = kernel.kernelOlder "5.15";
  };
}
