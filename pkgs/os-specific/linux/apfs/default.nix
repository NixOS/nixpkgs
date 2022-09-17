{ lib
, stdenv
, fetchFromGitHub
, kernel
}:

stdenv.mkDerivation {
  pname = "apfs";
  version = "unstable-2022-07-24-${kernel.version}";

  src = fetchFromGitHub {
    owner = "linux-apfs";
    repo = "linux-apfs-rw";
    rev = "925d86b7be3ccf21b17734cfececf40e43c4598e";
    sha256 = "sha256-N5lGJu4c03cVDk3WTcegzZHBDmguPEX8dCedJS2TMSI=";
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
    broken = kernel.kernelOlder "4.9" || kernel.kernelAtLeast "5.19";
    maintainers = with maintainers; [ Luflosi ];
  };
}
