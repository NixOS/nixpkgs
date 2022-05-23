{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, kernel
}:

stdenv.mkDerivation {
  pname = "apfs";
  version = "unstable-2022-02-03-${kernel.version}";

  src = fetchFromGitHub {
    owner = "linux-apfs";
    repo = "linux-apfs-rw";
    rev = "a0d6a4dca69b6eab3cabaaee4d4284807828a266";
    sha256 = "sha256-3T1BNc6g3SDTxb0VrronLUIp/CWbwnzXTsc8Qk5c4jY=";
  };

  patches = [
    # Fix build for Linux 5.18+.
    # https://github.com/linux-apfs/linux-apfs-rw/pull/24
    (fetchpatch {
      url = "https://github.com/linux-apfs/linux-apfs-rw/commit/93b93767acab614c4e6426c9fd38bdf9af00bc13.patch";
      sha256 = "1ss7cal851qadcmkn3jcckpa2f003nzb03xsx1g8vkb1cl0n8gi7";
    })
  ];

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
