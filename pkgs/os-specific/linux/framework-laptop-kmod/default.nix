{
  lib,
  stdenv,
  kernel,
  kernelModuleMakeFlags,
  fetchFromGitHub,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "framework-laptop-kmod";
  version = "0-unstable-2024-09-15";

  src = fetchFromGitHub {
    owner = "DHowett";
    repo = "framework-laptop-kmod";
    rev = "6164bc3dec24b6bb2806eedd269df6a170bcc930";
    hash = "sha256-OwtXQR0H4GNlYjVZ5UU5MEM6ZOjlV3B0x2auYawbS2U=";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = kernelModuleMakeFlags ++ [
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "INSTALL_MOD_PATH=${placeholder "out"}"
    "INSTALL_MOD_DIR=extra"
    "DEPMOD=true"
  ];

  installTargets = [ "modules_install" ];

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Kernel module that exposes the Framework Laptop (13, 16)'s battery charge limit and LEDs to userspace";
    homepage = "https://github.com/DHowett/framework-laptop-kmod";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ gaykitty ];
    platforms = lib.platforms.linux;
    broken = lib.versionOlder kernel.version "6.1";
  };
}
