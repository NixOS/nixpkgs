{
  lib,
  pkgs,
  nixpkgsFun,
}:
let
  withRuntime =
    runtime:
    nixpkgsFun {
      localSystem = "x86_64-linux";
      crossSystem = {
        system = "aarch64-linux";
        useLLVM = true;
        linker = "lld";
      };
      config.replaceCrossStdenv =
        { buildPackages, baseStdenv }:
        buildPackages.overrideCC baseStdenv (
          if runtime == "libstdcxx" then
            buildPackages.llvmPackages.clangUseLLVM.override {
              libcxx = buildPackages.targetPackages.gccNGPackages.libstdcxx;
              # Preserve the implicit GNU provider policy too. These fields
              # remain meaningful metadata even when useLLVM selects libcxx.
              gccForLibs = buildPackages.gcc14.cc;
              useCcForLibs = false;
            }
          else
            buildPackages.llvmPackages.clangUseLLVM
        );
    };
  preservesRuntime =
    runtime:
    let
      packages = withRuntime runtime;
      compiler = packages.stdenv.cc;
      targetCompiler = packages.targetPackages.stdenv.cc;
    in
    compiler.isClang
    && targetCompiler.isClang
    && compiler.libcxx.outPath == targetCompiler.libcxx.outPath
    && compiler.gccForLibs.outPath == targetCompiler.gccForLibs.outPath
    && compiler.useCcForLibs == targetCompiler.useCcForLibs
    && compiler.nixSupport == targetCompiler.nixSupport
    &&
      map toString compiler.depsTargetTargetPropagated
      == map toString targetCompiler.depsTargetTargetPropagated
    && lib.systems.equals targetCompiler.stdenv.hostPlatform packages.stdenv.hostPlatform
    && lib.systems.equals targetCompiler.stdenv.targetPlatform packages.stdenv.targetPlatform
    # Role metadata alone can hide a bootstrap dependency cycle.
    && builtins.isString compiler.drvPath
    && builtins.isString targetCompiler.drvPath;
in
assert lib.all preservesRuntime [
  "libstdcxx"
  "libcxx"
];
pkgs.emptyFile
