{ lib
, stdenv
, fetchFromGitHub
, ivsc-driver
, kernel
}:

stdenv.mkDerivation rec {
  pname = "ipu6-drivers";
  version = "unstable-2023-02-20";

  src = fetchFromGitHub {
    owner = "intel";
    repo = pname;
    rev = "dfedab03f3856010d37968cb384696038c73c984";
    hash = "sha256-TKo04+fqY64SdDuWApuzRXBnaAW2DReubwFRsdfJMWM=";
  };

  patches = [
    # https://github.com/intel/ipu6-drivers/pull/84
    ./pr-84-unpatched-upstream-compatiblity.patch
  ];

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
    broken = kernel.kernelOlder "6.1.7";
  };
}
