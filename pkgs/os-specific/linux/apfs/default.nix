{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
  kernelModuleMakeFlags,
  nixosTests,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "apfs";
  version = "0.3.14";

  src = fetchFromGitHub {
    owner = "linux-apfs";
    repo = "linux-apfs-rw";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bv3WGcIKx5RVj+cQg0U5U1zGPRzjxMlCZmol9QvAmc4=";
  };

  hardeningDisable = [ "pic" ];
  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = kernelModuleMakeFlags ++ [
    "KERNELRELEASE=${kernel.modDirVersion}"
    "KERNEL_DIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "INSTALL_MOD_PATH=$(out)"
  ];

  passthru.tests.apfs = nixosTests.apfs;
  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
  };

  meta = with lib; {
    description = "APFS module for linux";
    longDescription = ''
      The Apple File System (APFS) is the copy-on-write filesystem currently
      used on all Apple devices. This module provides a degree of experimental
      support on Linux.
      If you make use of the write support, expect data corruption.
      Read-only support is somewhat more complete, with sealed volumes,
      snapshots, and all the missing compression algorithms recently added.
      Encryption is still not in the works though.
    '';
    homepage = "https://github.com/linux-apfs/linux-apfs-rw";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ Luflosi ];
  };
})
