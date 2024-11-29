{
  lib,
  stdenv,
  mkDerivation,
  libelf,
}:
mkDerivation {
  path = "usr.bin/ldd";
  extraPaths = [
    "libexec/rtld-elf"
    "contrib/elftoolchain/libelf"
  ];

  buildInputs = [ libelf ];

  env = {
    NIX_CFLAGS_COMPILE = "-D_RTLD_PATH=${lib.getLib stdenv.cc.libc}/libexec/ld-elf.so.1";
  };

  meta.platforms = lib.platforms.freebsd;
}
