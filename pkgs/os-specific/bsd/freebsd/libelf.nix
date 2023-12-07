{ mkDerivation, libc, bsdSetupHook, freebsdSetupHook, bmakeMinimal, buildFreebsd, buildPackages, ...}:
mkDerivation {
  path = "lib/libelf";
  extraPaths = ["lib/libc" "contrib/elftoolchain" "sys/sys/elf32.h" "sys/sys/elf64.h" "sys/sys/elf_common.h"];
  buildInputs = [libc];
  nativeBuildInputs = [
    bsdSetupHook freebsdSetupHook
    buildFreebsd.bmakeMinimal  # TODO bmake??
    buildFreebsd.install buildPackages.m4
  ];
}
