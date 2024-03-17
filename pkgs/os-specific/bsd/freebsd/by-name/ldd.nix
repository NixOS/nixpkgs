{ lib, stdenv, mkDerivation, libelf, ... }:
mkDerivation ({
  path = "usr.bin/ldd";
  extraPaths = ["libexec/rtld-elf" "contrib/elftoolchain/libelf"];

  buildInputs = [libelf];

  env = lib.optionalAttrs (stdenv.name != "stdenv-freebsd") {
    NIX_CFLAGS_COMPILE = "-D_RTLD_PATH=${lib.getLib stdenv.cc.libc}/libexec/ld-elf.so.1";
  };

  meta.platforms = lib.platforms.freebsd;
} // lib.optionalAttrs (stdenv.name == "stdenv-freebsd") {
  NIX_CFLAGS_COMPILE = ''-D_PATH_RTLD="${lib.getLib stdenv.cc.libc}/libexec/ld-elf.so.1"'';
})
