# Exercise a HOST compiler using the existing BUILD -> HOST GCC runtime provider.
{
  lib,
  stdenv,
  llvmPackages,
  pkgsBuildHost,
  runCommand,
}:
let
  provider = pkgsBuildHost.gcc.cc;
  compiler = llvmPackages.libstdcxxClang.override { gccForLibs = provider; };
  linker = pkgsBuildHost.bintools;
in
assert lib.systems.equals compiler.stdenv.hostPlatform compiler.stdenv.targetPlatform;
assert lib.systems.equals provider.stdenv.targetPlatform stdenv.hostPlatform;
runCommand "cc-wrapper-gcc-for-libs"
  {
    passthru = { inherit compiler provider linker; };
    meta.platforms = lib.platforms.linux;
  }
  ''
    # Only the installed compiler's advertised search paths may find the archive.
    # This works on BUILD without executing the HOST compiler or a GPU program.
    mapfile -t paths < <(tr ' ' '\n' < ${compiler}/nix-support/cc-ldflags | grep '^-L')
    env -i ${lib.getExe' linker.bintools "${linker.targetPrefix}ld"} \
      -r --whole-archive "''${paths[@]}" -lstdc++fs -o archive.o
    mkdir -p "$out"
    ${lib.getExe' linker.bintools "${linker.targetPrefix}readelf"} -h archive.o > "$out/elf-header"
    cp archive.o "$out/"
    cp ${compiler}/nix-support/cc-ldflags "$out/cc-ldflags"
  ''
