{
  lib,
  stdenv,
  fetchFromGitHub,
  ivsc-driver,
  kernel,
}:

stdenv.mkDerivation rec {
  pname = "ipu6-drivers";
  version = "unstable-2024-11-19";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "ipu6-drivers";
    rev = "0ad4988248d7e9382498a0b47fc78bb990b29a58";
    hash = "sha256-UFvwuoAzwk1k4YiUK+4EeMKeTx9nVvBgBN5JKAfqZkQ=";
  };

  patches = [
    "${src}/patches/0001-v6.10-IPU6-headers-used-by-PSYS.patch"
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
    license = lib.licenses.gpl2Only;
    maintainers = [ ];
    platforms = [ "x86_64-linux" ];
    # requires 6.10
    broken = kernel.kernelOlder "6.10";
  };
}
