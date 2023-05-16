{ lib
, stdenv
, fetchFromGitHub
, kernel
}:

<<<<<<< HEAD
stdenv.mkDerivation {
  pname = "ivsc-driver";
  version = "unstable-2023-03-10";
=======
stdenv.mkDerivation rec {
  pname = "ivsc-drivers";
  version = "unstable-2023-01-06";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "intel";
    repo = "ivsc-driver";
<<<<<<< HEAD
    rev = "c8db12b907e2e455d4d5586e5812d1ae0eebd571";
    hash = "sha256-OM9PljvaMKrk72BFeSCqaABFeAws+tOdd3oC2jyNreE=";
=======
    rev = "94ecb88b3ac238d9145ac16230d6e0779bb4fd32";
    hash = "sha256-Q7iyKw4WFSX42E4AtoW/zYRKpknWZSU66V5VPAx6AjA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    homepage = "https://github.com/intel/ivsc-driver";
=======
    homepage = "https://github.com/intel/ivsc-drivers";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    description = "Intel Vision Sensing Controller kernel driver";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ hexa ];
    platforms = [ "x86_64-linux" ];
    broken = kernel.kernelOlder "5.15";
  };
}
