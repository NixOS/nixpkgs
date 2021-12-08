{ lib
, stdenv
, fetchFromGitHub
, kernel
, buildModule
}:

buildModule {
  pname = "apfs";
  version = "unstable-2021-09-21-${kernel.version}";

  src = fetchFromGitHub {
    owner = "linux-apfs";
    repo = "linux-apfs-rw";
    rev = "362c4e32ab585b9234a26aa3e49f29b605612a31";
    sha256 = "sha256-Y8/PGPLirNrICF+Bum60v/DBPa1xpox5VBvt64myZzs=";
  };

  hardeningDisable = [ "pic" ];

  makeFlags = [
    "KERNELRELEASE=${kernel.modDirVersion}"
  ];

  meta = with lib; {
    description = "APFS module for linux";
    homepage = "https://github.com/linux-apfs/linux-apfs-rw";
    license = licenses.gpl2Only;
    broken = kernel.kernelOlder "4.9";
    maintainers = with maintainers; [ Luflosi ];
  };
}
