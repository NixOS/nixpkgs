{
  stdenv,
  lib,
  kernel,
  kernelModuleMakeFlags,
  libajantv2,
}:
stdenv.mkDerivation (finalAttrs: {
  name = "${finalAttrs.pname}-${finalAttrs.version}-${kernel.version}";
  pname = "ajantv2-module";
  version = libajantv2.version;

  __structuredAttrs = true;

  inherit (libajantv2) src;
  sourceRoot = "${libajantv2.src.name}/driver/linux";

  patches = [
    ./fix-linux-6.15.patch
  ];
  patchFlags = "-p3";

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = kernelModuleMakeFlags ++ [
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  preBuild = ''
    chmod -R +w ../../
  '';

  enableParallelBuilding = true;

  kmods = [
    "ajantv2"
    "ajardma"
  ];

  postBuild = ''
    for kmod in "''${kmods[@]}"; do
      echo "compressing $kmod" >&2
      xz -k ''${kmod}.ko
    done
  '';

  installPhase = ''
    for kmod in "''${kmods[@]}"; do
      install ''${kmod}.ko.xz $out/lib/modules/${kernel.modDirVersion}/misc/''${kmod}.ko.xz
    done
  '';

  meta = {
    inherit (libajantv2.meta) license homepage maintainers;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    description = "AJA video driver";
  };
})
