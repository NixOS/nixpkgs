{ stdenv, deepin, kernel }:

stdenv.mkDerivation {
  pname = "deepin-anything-module";
  version = "${deepin.deepin-anything.version}-${kernel.version}";
  src = deepin.deepin-anything.modsrc;

  nativeBuildInputs = kernel.moduleBuildDependencies;

  buildPhase = ''
    make -C src/deepin-anything-0.0 kdir=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build
  '';

  installPhase = ''
     install -m 644 -D -t $out/lib/modules/${kernel.modDirVersion}/extra src/deepin-anything-0.0/*.ko
  '';

  meta = deepin.deepin-anything.meta // {
    description = deepin.deepin-anything.meta.description + " (kernel modules)";
    badPlatforms = [ "aarch64-linux" ];  # the kernel module is not building
  };
}
