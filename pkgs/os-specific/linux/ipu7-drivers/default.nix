{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
  kernelModuleMakeFlags,
}:

stdenv.mkDerivation {
  pname = "ipu7-drivers";
  version = "20260926_1900_40";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "ipu7-drivers";
    rev = "20260926_1900_40";
    hash = "sha256-JdCtc+BWp9BlhyilVTwpBEWw4zxk/2VfaYfgX0O+vzw=";
  };

  patches = [
    ./ipu7-psys-in-tree-core-abi.patch # https://github.com/intel/ipu7-drivers/pull/120
  ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = kernelModuleMakeFlags ++ [
    "KERNELRELEASE=${kernel.modDirVersion}"
    "KERNEL_SRC=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  enableParallelBuilding = true;

  preInstall = ''
    substituteInPlace Makefile \
      --replace-fail "INSTALL_MOD_DIR=" "INSTALL_MOD_PATH=$out INSTALL_MOD_DIR="
  '';

  installTargets = [
    "modules_install"
  ];

  meta = {
    homepage = "https://github.com/intel/ipu7-drivers";
    description = "IPU7 kernel driver";
    license = lib.licenses.gpl2Only;
    maintainers = [
      lib.maintainers.aoli-al
      lib.maintainers.pseudocc
    ];
    platforms = [ "x86_64-linux" ];
    broken = kernel.kernelOlder "6.12";
  };
}
