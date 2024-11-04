{
  stdenv,
  lib,
  fetchFromGitHub,
  linuxPackages,
  git,
  kernel ? linuxPackages.kernel,
}:
stdenv.mkDerivation {
  pname = "msi-ec-kmods";
  version = "0-unstable-2024-11-04";

  src = fetchFromGitHub {
    owner = "BeardOverflow";
    repo = "msi-ec";
    rev = "be6f7156cd15f6ecf9d48dfcc30cbd1f693916b8";
    hash = "sha256-gImiP4OaBt80n+qgVnbhd0aS/zW+05o3DzGCw0jq+0g=";
  };

  dontMakeSourcesWritable = false;

  patches = [ ./patches/makefile.patch ];

  hardeningDisable = [ "pic" ];

  makeFlags = kernel.makeFlags ++ [
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
