{ lib
, stdenv
, fetchFromGitHub
, kernel
, nixosTests
}:

stdenv.mkDerivation {
  pname = "apfs";
  version = "unstable-2022-10-20-${kernel.version}";

  src = fetchFromGitHub {
    owner = "linux-apfs";
    repo = "linux-apfs-rw";
    rev = "e6eb67c92d425d395eac1c4403629391bdd5064d";
    sha256 = "sha256-6rv5qZCjOqt0FaNFhA3tYg6/SdssvoT8kPVhalajgOo=";
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
    homepage = "https://github.com/linux-apfs/linux-apfs-rw";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    broken = kernel.kernelOlder "4.9";
    maintainers = with maintainers; [ Luflosi ];
  };
}
