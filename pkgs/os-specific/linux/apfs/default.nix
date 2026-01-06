{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
  kernelModuleMakeFlags,
  nixosTests,
}:

let
  tag = "0.3.16";
in
stdenv.mkDerivation {
  pname = "apfs";
  version = "${tag}-${kernel.version}";

  src = fetchFromGitHub {
    owner = "linux-apfs";
    repo = "linux-apfs-rw";
    tag = "v${tag}";
    hash = "sha256-11ypevJwxNKAmJbl2t+nGXq40hjWbLIdltLqSeTVdHc=";
  };

  hardeningDisable = [ "pic" ];
  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = kernelModuleMakeFlags ++ [
    "KERNELRELEASE=${kernel.modDirVersion}"
    "KERNEL_DIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "INSTALL_MOD_PATH=$(out)"
  ];

  passthru = {
    tests.apfs = nixosTests.apfs;

    inherit tag;
    updateScript = ./update.sh;
  };

  meta = {
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
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ Luflosi ];
  };
}
