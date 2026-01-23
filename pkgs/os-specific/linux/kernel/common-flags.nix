{
  lib,
  stdenv,
  buildPackages,
  extraMakeFlags ? [ ],
}:
# Absolute paths for compilers avoid any PATH-clobbering issues.
[
  #
  # We use the unwrapped compiler, because the clang-wrapper doesn't like -target.
  "CC=${lib.getExe stdenv.cc.cc}"
  # The wrapper for ld.lld breaks linking the kernel. We use the unwrapped linker as workaround. See:
  # https://github.com/NixOS/nixpkgs/issues/321667
  "LD=${lib.getExe' stdenv.cc.bintools.bintools "${stdenv.cc.targetPrefix}ld"}"
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
++ lib.optionals (stdenv.cc.isClang) (
  let
    clangLib = lib.getLib stdenv.cc.cc;
    majorVer = lib.versions.major clangLib.version;
  in
  [
    "CFLAGS_MODULE=-I${clangLib}/lib/clang/${majorVer}/include"
    "CFLAGS_KERNEL=-I${clangLib}/lib/clang/${majorVer}/include"
  ]
)
++ (stdenv.hostPlatform.linux-kernel.makeFlags or [ ])
++ extraMakeFlags
