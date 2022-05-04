{ lib
, stdenv
, fetchFromGitHub
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
