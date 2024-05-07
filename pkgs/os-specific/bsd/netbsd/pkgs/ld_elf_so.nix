{
  lib,
  mkDerivation,
  libc,
  defaultMakeFlags,
}:

mkDerivation {
  path = "libexec/ld.elf_so";
  version = "9.2";
  sha256 = "0ia9mqzdljly0vqfwflm5mzz55k7qsr4rw2bzhivky6k30vgirqa";
  meta.platforms = lib.platforms.netbsd;
  LIBC_PIC = "${libc}/lib/libc_pic.a";
  # Hack to prevent a symlink being installed here for compatibility.
  SHLINKINSTALLDIR = "/usr/libexec";
  USE_FORT = "yes";
  makeFlags = defaultMakeFlags ++ [
    "BINDIR=$(out)/libexec"
    "CLIBOBJ=${libc}/lib"
  ];
  extraPaths = [ libc.src ] ++ libc.extraPaths;
}
