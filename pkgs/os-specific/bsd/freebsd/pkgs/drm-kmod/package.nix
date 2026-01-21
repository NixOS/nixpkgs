{
  lib,
  mkDerivation,
  fetchFromGitHub,
  xargs-j,
  versionData,
  sys,
}:
let
  # Based off ports tree versions
  reldate = lib.toIntBase10 versionData.reldate;
  branch =
    if reldate >= 1500008 then
      "6.6-lts"
    else if reldate >= 1400097 then
      "6.1-lts"
    else if reldate >= 1302000 then
      "5.10-lts"
    else
      throw "drm-kmod not supported on FreeBSD version ${reldate}";

  fetchOptions = (lib.importJSON ./versions.json).${branch};
in
mkDerivation rec {
  # this derivation is tricky; it is not an in-tree FreeBSD build but it is meant to be built
  # at the same time as the in-tree FreeBSD code, so it expects the same environment. Therefore,
  # it is appropriate to use the freebsd mkDerivation.
  path = "...";
  pname = "drm-kmod";
  version = branch;

  src = fetchFromGitHub fetchOptions;

  outputs = [
    "out"
    "debug"
  ];

  extraNativeBuildInputs = [ xargs-j ];

  hardeningDisable = [
    "pic" # generates relocations the linker can't handle
    "stackprotector" # generates stack protection for the function generating the stack canary
  ];

  # hardeningDisable = stackprotector doesn't seem to be enough, put it in cflags too
  NIX_CFLAGS_COMPILE = [
    "-fno-stack-protector"
    "-Wno-unneeded-internal-declaration" # some openzfs code trips this
    "-Wno-default-const-init-field-unsafe" # added in clang 21
    "-Wno-uninitialized-const-pointer" # added in clang 21
    "-Wno-format" # error: passing 'printf' format string where 'freebsd_kprintf' format string is expected
    "-Wno-sometimes-uninitialized" # this one is actually kind of concerning but it does trip
    "-Wno-unused-function"
  ];

  env = sys.passthru.env;
  SYSDIR = "${sys.src}/sys";

  KMODDIR = "${placeholder "out"}/kernel";
  KERN_DEBUGDIR = "${placeholder "debug"}/lib/debug";
  KERN_DEBUGDIR_KODIR = "${KERN_DEBUGDIR}/kernel";
  KERN_DEBUGDIR_KMODDIR = "${KERN_DEBUGDIR}/kernel";

  preBuild = ''
    mkdir -p linuxkpi/dummy/include
  '';

  makeFlags = [
    "DEBUG_FLAGS=-g"
  ];

  meta = {
    description = "Linux drm driver, ported to FreeBSD";
    platforms = lib.platforms.freebsd;
    license = with lib.licenses; [
      bsd2
      gpl2Only
    ];
  };
}
