{
  lib,
  stdenv,
  fetchpatch,
  kernel,
  looking-glass-client,
}:

stdenv.mkDerivation {
  pname = "kvmfr";
  version = looking-glass-client.version;

  src = looking-glass-client.src;
  sourceRoot = "${looking-glass-client.src.name}/module";
  hardeningDisable = [
    "pic"
    "format"
  ];
  nativeBuildInputs = kernel.moduleBuildDependencies;

  patches = [
    # fix build for linux-6_10
    (fetchpatch {
      url = "https://github.com/gnif/LookingGlass/commit/7305ce36af211220419eeab302ff28793d515df2.patch";
      hash = "sha256-97nZsIH+jKCvSIPf1XPf3i8Wbr24almFZzMOhjhLOYk=";
      stripLen = 1;
    })

    # securtiy patch for potential buffer overflow
    # https://github.com/gnif/LookingGlass/issues/1133
    (fetchpatch {
      url = "https://github.com/gnif/LookingGlass/commit/3ea37b86e38a87ee35eefb5d8fcc38b8dc8e2903.patch";
      hash = "sha256-Kk1gN1uB86ZJA374zmzM9dwwfMZExJcix3hee7ifpp0=";
      stripLen = 1;
    })
  ];

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
