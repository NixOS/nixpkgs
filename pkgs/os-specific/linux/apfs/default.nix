{ lib
, stdenv
, fetchFromGitHub
, kernel
, nixosTests
}:

let
  tag = "0.3.0";
in
stdenv.mkDerivation {
  pname = "apfs";
  version = "${tag}-${kernel.version}";

  src = fetchFromGitHub {
    owner = "linux-apfs";
    repo = "linux-apfs-rw";
    rev = "v${tag}";
    sha256 = "sha256-ABFqkiIJuFapFsUIFHfw8+TujePZm7ZX/qHuFO2KdnQ=";
  };

  hardeningDisable = [ "pic" ];
  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = kernel.makeFlags ++ [
    "KERNELRELEASE=${kernel.modDirVersion}"
    "KERNEL_DIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "INSTALL_MOD_PATH=$(out)"
  ];

  passthru.tests.test = nixosTests.apfs;

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
    broken = kernel.kernelOlder "4.9";
    maintainers = with maintainers; [ Luflosi ];
  };
}
