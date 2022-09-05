{ lib
, stdenv
, fetchFromGitHub
, kernel
}:

stdenv.mkDerivation {
  pname = "apfs";
  version = "unstable-2022-08-15-${kernel.version}";

  src = fetchFromGitHub {
    owner = "linux-apfs";
    repo = "linux-apfs-rw";
    rev = "e4bf2d51d3fe8485ad2b28a89c157ada32ee3d77";
    sha256 = "sha256-zvl1H9AIExgt6t2A2w7zDwXmRsmLY8y3P6EfbBuFdh8=";
  };

  hardeningDisable = [ "pic" ];
  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = kernel.makeFlags ++ [
    "KERNELRELEASE=${kernel.modDirVersion}"
    "KERNEL_DIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "INSTALL_MOD_PATH=$(out)"
  ];

  meta = with lib; {
    description = "APFS module for linux";
    homepage = "https://github.com/linux-apfs/linux-apfs-rw";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    broken = kernel.kernelOlder "4.9";
    maintainers = with maintainers; [ Luflosi ];
  };
}
