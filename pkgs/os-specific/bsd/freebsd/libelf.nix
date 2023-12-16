{ mkDerivation, lib, bsdSetupHook, freebsdSetupHook, stdenv, buildFreebsd, buildPackages, ...}:
mkDerivation {
  path = "lib/libelf";
  extraPaths = ["lib/libc" "contrib/elftoolchain" "sys/sys/elf32.h" "sys/sys/elf64.h" "sys/sys/elf_common.h"];
  buildInputs = [];
  nativeBuildInputs = [
    bsdSetupHook freebsdSetupHook
    buildFreebsd.bmakeMinimal  # TODO bmake??
    buildFreebsd.install buildPackages.m4
  ];
  preBuild = lib.optionalString stdenv.cc.isClang ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -D_VA_LIST -D_VA_LIST_DECLARED -Dva_list=__builtin_va_list -D_SIZE_T -D_WCHAR_T"
  '';
}
