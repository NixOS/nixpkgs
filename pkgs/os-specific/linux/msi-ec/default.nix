{
  stdenv,
  lib,
  fetchFromGitHub,
  linuxPackages,
  git,
  kernel ? linuxPackages.kernel,
  kernelModuleMakeFlags,
}:
stdenv.mkDerivation {
  pname = "msi-ec-kmods";
  version = "0-unstable-2025-05-17";

  src = fetchFromGitHub {
    owner = "BeardOverflow";
    repo = "msi-ec";
    rev = "796be9047b13c311ac4cdec33913775f4057f600";
    hash = "sha256-npJbnWFBVb8TK9ynVD/kXWq2iqO0ACKF4UYsu5mQuok=";
  };

  dontMakeSourcesWritable = false;

  patches = [
    ./patches/makefile.patch
    ./patches/kernel-string-choices.patch
  ];

  hardeningDisable = [ "pic" ];

  makeFlags = kernelModuleMakeFlags ++ [
    "KERNELDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "INSTALL_MOD_PATH=$(out)"
  ];

  nativeBuildInputs = kernel.moduleBuildDependencies ++ [ git ];

  installTargets = [ "modules_install" ];

  enableParallelBuilding = true;

  meta = {
    description = "Kernel modules for MSI Embedded controller";
    homepage = "https://github.com/BeardOverflow/msi-ec";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.m1dugh ];
    platforms = lib.platforms.linux;
    broken = kernel.kernelOlder "5.5";
  };
}
