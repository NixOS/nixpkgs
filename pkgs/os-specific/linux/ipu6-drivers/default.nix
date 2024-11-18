{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, ivsc-driver
, kernel
}:

stdenv.mkDerivation rec {
  pname = "ipu6-drivers";
  version = "unstable-2024-10-10";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "ipu6-drivers";
    rev = "118952d49ec598f56add50d93fa7bc3ac4a05643";
    hash = "sha256-xdMwINoKrdRHCPMpdZQn86ATi1dAXncMU39LLXS16mc=";
  };

  patches = [
    "${src}/patches/0001-v6.10-IPU6-headers-used-by-PSYS.patch"


    # Fix compilation with kernels >= 6.12
    # https://github.com/intel/ipu6-drivers/pull/283
    (fetchpatch {
      url = "https://github.com/intel/ipu6-drivers/pull/283/commits/391832777148e8e59ebf08e5d04f87dc8f3cef5b.patch";
      hash = "sha256-oC7wn4jrHNtvsgouq7F+ufIE02pJcm42ZmgU2TrAvjA=";
    })
    (fetchpatch {
      url = "https://github.com/intel/ipu6-drivers/pull/283/commits/5379758bcb21be56b600817edf989dcc2c1775cf.patch";
      hash = "sha256-9nOm0ffSNoyVV1y4J6RKBVRVYRxrEPOnggFXGIExLxs=";
    })
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
