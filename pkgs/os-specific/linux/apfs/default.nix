{ lib
, stdenv
, fetchFromGitHub
, kernel
}:

stdenv.mkDerivation {
  pname = "apfs";
  version = "unstable-2021-06-25-${kernel.version}";

  src = fetchFromGitHub {
    owner = "linux-apfs";
    repo = "linux-apfs-rw";
    rev = "2ce6d06dc73036d113da5166c59393233bf54229";
    sha256 = "sha256-18HFtPr0qcTIZ8njwEtveiPYO+HGlj90bdUoL47UUY0=";
  };

  hardeningDisable = [ "pic" ];
  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = [
    "KERNELRELEASE=${kernel.modDirVersion}"
    "KERNEL_DIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "INSTALL_MOD_PATH=$(out)"
  ];

  meta = with lib; {
    description = "APFS module for linux";
    homepage = "https://github.com/linux-apfs/linux-apfs-rw";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    broken = kernel.kernelOlder "4.19";
    maintainers = with maintainers; [ Luflosi ];
  };
}
