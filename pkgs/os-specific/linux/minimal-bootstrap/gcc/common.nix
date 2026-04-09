{
  lib,
  bash,
  fetchurl,
  gnutar,
  xz,
}:
let
  version = "15.2.0";
  src = fetchurl {
    url = "mirror://gnu/gcc/gcc-${version}/gcc-${version}.tar.xz";
    hash = "sha256-Q4/ZloJrDIJIWinaA6ctcdbjVBqD7HAt9Ccfb+Al0k4=";
  };
in
{
  inherit src version;
  monorepoSrc =
    bash.runCommand "gcc-${version}-src"
      {
        nativeBuildInputs = [
          gnutar
          xz
        ];
      }
      ''
        mkdir $out/
        tar xf ${src} --directory=$out/ --strip-components=1
      '';
  meta = {
    description = "GNU Compiler Collection, version ${version}";
    homepage = "https://gcc.gnu.org";
    license = lib.licenses.gpl3Plus;
    teams = [ lib.teams.minimal-bootstrap ];
    platforms = lib.platforms.unix;
  };
  # adapted from bintools-wrapper
  dynamicLinkerGlob =
    targetPlatform: libc:
    if targetPlatform.libc == "musl" then
      "${libc}/lib/ld-musl-*"
    else if targetPlatform.libc == "uclibc" then
      "${libc}/lib/ld*-uClibc.so.1"
    else if (targetPlatform.libc == "bionic" && targetPlatform.is32bit) then
      "/system/bin/linker"
    else if (targetPlatform.libc == "bionic" && targetPlatform.is64bit) then
      "/system/bin/linker64"
    else if targetPlatform.libc == "nblibc" then
      "${libc}/libexec/ld.elf_so"
    else if targetPlatform.system == "i686-linux" then
      "${libc}/lib/ld-linux.so.2"
    else if targetPlatform.system == "x86_64-linux" then
      "${libc}/lib/ld-linux-x86-64.so.2"
    else if targetPlatform.system == "s390x-linux" then
      "${libc}/lib/ld64.so.1"
    # ELFv1 (.1) or ELFv2 (.2) ABI
    else if targetPlatform.isPower64 then
      "${libc}/lib/ld64.so.*"
    # ARM with a wildcard, which can be "" or "-armhf".
    else if (with targetPlatform; isAarch32 && isLinux) then
      "${libc}/lib/ld-linux*.so.3"
    else if targetPlatform.system == "aarch64-linux" then
      "${libc}/lib/ld-linux-aarch64.so.1"
    else if targetPlatform.system == "powerpc-linux" then
      "${libc}/lib/ld.so.1"
    else if targetPlatform.system == "s390-linux" then
      "${libc}/lib/ld.so.1"
    else if targetPlatform.system == "s390x-linux" then
      "${libc}/lib/ld64.so.1"
    else if targetPlatform.isMips then
      "${libc}/lib/ld.so.1"
    # `ld-linux-riscv{32,64}-<abi>.so.1`
    else if targetPlatform.isRiscV then
      "${libc}/lib/ld-linux-riscv*.so.1"
    else if targetPlatform.isLoongArch64 then
      "${libc}/lib/ld-linux-loongarch*.so.1"
    else if targetPlatform.isDarwin then
      "/usr/lib/dyld"
    else if targetPlatform.isFreeBSD then
      "${libc}/libexec/ld-elf.so.1"
    else if targetPlatform.isOpenBSD then
      "${libc}/libexec/ld.so"
    else if lib.hasSuffix "pc-gnu" targetPlatform.config then
      "ld.so.1"
    else
      "";
}
