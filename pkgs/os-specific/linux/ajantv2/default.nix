{
  stdenv,
  kernel,
  kernelModuleInstallHook,
  kernelModuleMakeFlags,
  libajantv2,
}:
stdenv.mkDerivation (finalAttrs: {
  name = "${finalAttrs.version}-${finalAttrs.version}-${kernel.version}";
  pname = "ajantv2-module";
  version = libajantv2.version;

  inherit (libajantv2) src;
  sourceRoot = "${libajantv2.src.name}/driver/linux";

  patches = [
    ./fix-linux-6.15.patch
  ];
  patchFlags = "-p3";

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = kernel.moduleBuildDependencies ++ [ kernelModuleInstallHook ];

  makeFlags = kernelModuleMakeFlags;

  preBuild = ''
    chmod -R +w ../../
  '';

  enableParallelBuilding = true;

  buildFlags = [
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  kernelModuleInstallDir = "misc";

  meta = {
    inherit (libajantv2.meta) license homepage maintainers;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    description = "AJA video driver";
  };
})
