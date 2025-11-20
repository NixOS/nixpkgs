{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
  kernelModuleMakeFlags,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lttng-modules-${kernel.version}";
  version = "2.14.3";

  src = fetchFromGitHub {
    owner = "lttng";
    repo = "lttng-modules";
    rev = "v${finalAttrs.version}";
    hash = "sha256-W9mfCMboVkImqBtUlTxoBkn3IHjjfbZiSaeoeFX5IcM=";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;

  hardeningDisable = [ "pic" ];

  makeFlags = kernelModuleMakeFlags ++ [
    "KERNELDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "INSTALL_MOD_PATH=${placeholder "out"}"
  ];

  installTargets = [ "modules_install" ];

  enableParallelBuilding = true;

  meta = {
    description = "Linux kernel modules for LTTng tracing";
    homepage = "https://lttng.org/";
    license = with lib.licenses; [
      lgpl21Only
      gpl2Only
      mit
    ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ bjornfor ];
    broken =
      (lib.versions.majorMinor kernel.modDirVersion) == "5.10"
      || (lib.versions.majorMinor kernel.modDirVersion) == "5.4";
  };
})
