{ lib, stdenv, fetchFromGitHub, fetchpatch, kernel, kmod, looking-glass-client }:

stdenv.mkDerivation rec {
  pname = "kvmfr";
  version = looking-glass-client.version;

  src = looking-glass-client.src;
  sourceRoot = "source/module";
  hardeningDisable = [ "pic" "format" ];
  nativeBuildInputs = kernel.moduleBuildDependencies;

  patches = lib.optional (kernel.kernelAtLeast "5.16") (fetchpatch {
    name = "kvmfr-5.16.patch";
    url = "https://github.com/gnif/LookingGlass/commit/a9b5302a517e19d7a2da114acf71ef1e69cfb497.patch";
    sha256 = "017nxlk2f7kyjp6llwa74dbczdb1jk8v791qld81dxhzkm9dyqqx";
    stripLen = 1;
  });

  makeFlags = [
    "KVER=${kernel.modDirVersion}"
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  installPhase = ''
    install -D kvmfr.ko -t "$out/lib/modules/${kernel.modDirVersion}/kernel/drivers/misc/"
  '';

  meta = with lib; {
    description = "Optional kernel module for LookingGlass";
    longDescription = ''
      This kernel module implements a basic interface to the IVSHMEM device for LookingGlass when using LookingGlass in VM->VM mode
      Additionally, in VM->host mode, it can be used to generate a shared memory device on the host machine that supports dmabuf
    '';
    homepage = "https://github.com/gnif/LookingGlass";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ j-brn ];
    platforms = [ "x86_64-linux" ];
    broken = kernel.kernelOlder "5.3";
  };
}
