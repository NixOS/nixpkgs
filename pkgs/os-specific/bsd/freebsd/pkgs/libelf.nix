{
  stdenv,
  mkDerivation,
  bsdSetupHook,
  freebsdSetupHook,
  makeMinimal,
  install,
  m4,
}:
mkDerivation {
  path = "lib/libelf";
  extraPaths = [
    "lib/libc"
    "contrib/elftoolchain"
    "sys/sys/elf32.h"
    "sys/sys/elf64.h"
    "sys/sys/elf_common.h"
  ];
  nativeBuildInputs = [
    bsdSetupHook
    freebsdSetupHook
    makeMinimal
    install
    m4
  ];

  BOOTSTRAPPING = !stdenv.hostPlatform.isFreeBSD;
}
