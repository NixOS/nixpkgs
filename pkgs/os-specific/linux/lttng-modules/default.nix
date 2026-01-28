{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
  kernelModuleMakeFlags,
}:

stdenv.mkDerivation rec {
  pname = "lttng-modules-${kernel.version}";
  version = "2.13.22";

  src = fetchFromGitHub {
    owner = "lttng";
    repo = "lttng-modules";
    rev = "v${version}";
    hash = "sha256-0fHjJBG/nTjXX8MVArvKDvn2ho9GLEodqAv/DcHLWis=";
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
    maintainers = [ lib.maintainers.bjornfor ];
    broken =
      (lib.versions.majorMinor kernel.modDirVersion) == "5.10"
      || (lib.versions.majorMinor kernel.modDirVersion) == "5.4";
  };
}
