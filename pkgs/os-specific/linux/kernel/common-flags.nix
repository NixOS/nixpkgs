{
  lib,
  stdenv,
  buildPackages,
  extraMakeFlags ? [ ],
}:
# Absolute paths for compilers avoid any PATH-clobbering issues.
[
  #
  # We use the unwrapped clang, because the clang-wrapper doesn't like -target.
  "CC=${
    if stdenv.cc.isClang then
      lib.getExe' stdenv.cc.cc "clang"
    else if stdenv.cc.isGNU then
      lib.getExe' stdenv.cc.cc "${stdenv.cc.targetPrefix}gcc"
    else
      lib.getExe' stdenv.cc.cc "cc"
  }"
  "LD=${
    lib.getExe' (
      if stdenv.isx86_64 && stdenv.cc.bintools.isLLVM then
        # The wrapper for ld.lld breaks linking the kernel. We use the unwrapped linker as workaround. See:
        # https://github.com/NixOS/nixpkgs/issues/321667
        stdenv.cc.bintools.bintools
      else
        stdenv.cc
    ) "${stdenv.cc.targetPrefix}ld"
  }"
  "AR=${lib.getExe' stdenv.cc "${stdenv.cc.targetPrefix}ar"}"
  "NM=${lib.getExe' stdenv.cc "${stdenv.cc.targetPrefix}nm"}"
  "STRIP=${lib.getExe' stdenv.cc.bintools.bintools "${stdenv.cc.targetPrefix}strip"}"
  "OBJCOPY=${lib.getExe' stdenv.cc "${stdenv.cc.targetPrefix}objcopy"}"
  "OBJDUMP=${lib.getExe' stdenv.cc "${stdenv.cc.targetPrefix}objdump"}"
  "READELF=${lib.getExe' stdenv.cc "${stdenv.cc.targetPrefix}readelf"}"
  "HOSTCC=${lib.getExe' buildPackages.stdenv.cc "${buildPackages.stdenv.cc.targetPrefix}cc"}"
  "HOSTCXX=${lib.getExe' buildPackages.stdenv.cc "${buildPackages.stdenv.cc.targetPrefix}c++"}"
  "HOSTAR=${lib.getExe' buildPackages.stdenv.cc.bintools "${buildPackages.stdenv.cc.targetPrefix}ar"}"
  "HOSTLD=${lib.getExe' buildPackages.stdenv.cc.bintools "${buildPackages.stdenv.cc.targetPrefix}ld"}"
  "ARCH=${stdenv.hostPlatform.linuxArch}"
  "CROSS_COMPILE=${stdenv.cc.targetPrefix}"
]
# Add the built in headers the kernel needs
++ lib.optionals (stdenv.cc.isClang) [
  "CFLAGS_MODULE=-I${lib.getLib stdenv.cc.cc}/lib/clang/${lib.versions.major stdenv.cc.cc.version}/include"
  "CFLAGS_KERNEL=-I${lib.getLib stdenv.cc.cc}/lib/clang/${lib.versions.major stdenv.cc.cc.version}/include"
]
++ (stdenv.hostPlatform.linux-kernel.makeFlags or [ ])
++ extraMakeFlags
