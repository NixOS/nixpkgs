{
  lib,
  mkDerivation,
  libc,
  defaultMakeFlags,
}:

mkDerivation {
  noLibc = true;
  path = "libexec/ld.elf_so";
  meta.platforms = lib.platforms.netbsd;
  LIBC_PIC = "${libc}/lib/libc_pic.a";
  # Hack to prevent a symlink being installed here for compatibility.
  SHLINKINSTALLDIR = "/usr/libexec";
  USE_FORT = "yes";
  makeFlags = defaultMakeFlags ++ [
    "BINDIR=$(out)/libexec"
    "CLIBOBJ=${libc}/lib"
  ];
  extraPaths = [ libc.path ] ++ libc.extraPaths;
}
