{
  stdenv,
  deepin,
  kernel,
}:

stdenv.mkDerivation {
  pname = "deepin-anything-module";
  inherit (deepin.deepin-anything) version src;
  sourceRoot = "${deepin.deepin-anything.src.name}/src/kernelmod";

  nativeBuildInputs = kernel.moduleBuildDependencies;

  buildPhase = ''
    runHook preBuild
    make kdir=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -D -t $out/lib/modules/${kernel.modDirVersion}/extra *.ko
    runHook postInstall
  '';

  meta = deepin.deepin-anything.meta // {
    description = "Deepin Anything file search tool (kernel modules)";
  };
}
