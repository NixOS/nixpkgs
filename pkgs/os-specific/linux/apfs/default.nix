{ lib
, stdenv
, fetchFromGitHub
, kernel
, nixosTests
}:

let
<<<<<<< HEAD
  tag = "0.3.3";
=======
  tag = "0.3.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
in
stdenv.mkDerivation {
  pname = "apfs";
  version = "${tag}-${kernel.version}";

  src = fetchFromGitHub {
    owner = "linux-apfs";
    repo = "linux-apfs-rw";
    rev = "v${tag}";
<<<<<<< HEAD
    hash = "sha256-dxbpJ9Jdn8u16yD001zCZxrr/nPbxdpF7JvU+oD+hTw=";
=======
    sha256 = "sha256-KYPZsCAEqJl0VjV/TmJWi20Y7yApIJH0YMwQIL80Ep4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  hardeningDisable = [ "pic" ];
  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = kernel.makeFlags ++ [
    "KERNELRELEASE=${kernel.modDirVersion}"
    "KERNEL_DIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "INSTALL_MOD_PATH=$(out)"
  ];

<<<<<<< HEAD
  passthru.tests.apfs = nixosTests.apfs;
=======
  passthru.tests.test = nixosTests.apfs;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
<<<<<<< HEAD
=======
    broken = kernel.kernelOlder "4.9";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    maintainers = with maintainers; [ Luflosi ];
  };
}
