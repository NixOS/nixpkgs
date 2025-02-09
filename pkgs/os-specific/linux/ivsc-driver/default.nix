{ lib
, stdenv
, fetchFromGitHub
, kernel
}:

stdenv.mkDerivation {
  pname = "ivsc-driver";
  version = "unstable-2023-03-10";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "ivsc-driver";
    rev = "c8db12b907e2e455d4d5586e5812d1ae0eebd571";
    hash = "sha256-OM9PljvaMKrk72BFeSCqaABFeAws+tOdd3oC2jyNreE=";
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
