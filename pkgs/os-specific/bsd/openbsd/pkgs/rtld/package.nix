{
  lib,
  mkDerivation,
}:

mkDerivation {
  path = "libexec/ld.so";
  extraPaths = [
    "lib/libc/string"
    "lib/csu/os-note-elf.h"
  ];
  patches = [
    ./ldso-fix-makefile.patch
  ];

  libcMinimal = true;

  NIX_CFLAGS_COMPILE = "-Wno-error";

  makeFlags = [ "STACK_PROTECTOR=1" ];

  # -fret-clean requires OpenBSD-specific patches to the compiler.
  postPatch = ''
    find . -type f -exec sed -i 's/-fret-clean//g' {} \;
  '';

  # DESTDIR is overridden in bsdSetupHook, just fixup afterwards
  postInstall = ''
    mv $out/bin $out/libexec
  '';

  outputs = [
    "out"
    "man"
  ];

  meta.platforms = lib.platforms.openbsd;
}
