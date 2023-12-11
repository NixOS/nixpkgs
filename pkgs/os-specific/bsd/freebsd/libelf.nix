{ mkDerivation, libc, bsdSetupHook, freebsdSetupHook, bmakeMinimal, buildFreebsd, buildPackages, ...}:
mkDerivation {
  path = "lib/libelf";
  extraPaths = ["lib/libc" "contrib/elftoolchain" "sys/sys/elf32.h" "sys/sys/elf64.h" "sys/sys/elf_common.h"];
  buildInputs = [];
  nativeBuildInputs = [
    bsdSetupHook freebsdSetupHook
    buildFreebsd.bmakeMinimal  # TODO bmake??
    buildFreebsd.install buildPackages.m4
  ];
  preBuild = ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -D_VA_LIST_DECLARED -D_SIZE_T -D_WCHAR_T"
  '';
}
