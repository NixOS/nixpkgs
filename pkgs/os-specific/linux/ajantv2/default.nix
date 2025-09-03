{
  stdenv,
  kernel,
  kernelModuleMakeFlags,
  libajantv2,
}:
stdenv.mkDerivation {
  name = "ajantv2-module-${libajantv2.version}-${kernel.version}";

  inherit (libajantv2) src;
  sourceRoot = "${libajantv2.src.name}/driver/linux";

  patches = [
    ./fix-linux-6.15.patch
  ];
  patchFlags = "-p3";

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = kernelModuleMakeFlags;

  preBuild = ''
    chmod -R +w ../../
  '';

  enableParallelBuilding = true;

  buildFlags = [
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  installPhase = ''
    install -D ajantv2.ko $out/lib/modules/${kernel.modDirVersion}/misc/ajantv2.ko
    install -D ajardma.ko $out/lib/modules/${kernel.modDirVersion}/misc/ajardma.ko
  '';

  meta = {
    inherit (libajantv2.meta) license homepage maintainers;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    description = "AJA video driver";
    # FTB for hardened 5.10/5.15 kernels
    broken = kernel.kernelOlder "6" && kernel.isHardened;
  };
}
