{
  stdenv,
  lib,
  buildPackages,
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

  env.KMODIGEST = lib.getExe buildPackages.kmodigest;
  kmods = [
    "ajantv2"
    "ajardma"
  ];

  postBuild = ''
    for kmod in "''${kmods[@]}"; do
      # ajantv2 uses its own build system and not the proper out-of-tree kernel bits
      # so we have to do this ourselves. Very dull.
      echo "kmodigest-ing $kmod" >&2
      $KMODIGEST ''${kmod}.ko
      echo "compressing $kmod" >&2
      xz -k ''${kmod}.ko
    done
  '';

  installPhase = ''
    for kmod in "''${kmods[@]}"; do
      install -D ''${kmod}.ko.cer $out/lib/modules/${kernel.modDirVersion}/misc/''${kmod}.ko.cer
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
