{
  lib,
  mkDerivation,
  libcMinimal,
  defaultMakeFlags,
}:

mkDerivation {
  noLibc = true;
  path = "libexec/ld.elf_so";
  meta.platforms = lib.platforms.netbsd;
  LIBC_PIC = "${libcMinimal}/lib/libc_pic.a";
  # Hack to prevent a symlink being installed here for compatibility.
  SHLINKINSTALLDIR = "/usr/libexec";
  USE_FORT = "yes";
  makeFlags = defaultMakeFlags ++ [
    "BINDIR=$(out)/libexec"
    "CLIBOBJ=${libcMinimal}/lib"
  ];
  extraPaths = [
    libcMinimal.path
    "sys"
  ];
}
