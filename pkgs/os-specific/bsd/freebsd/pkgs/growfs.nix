{
  lib,
  mkDerivation,
  libufs,
  libutil,
}:
mkDerivation {
  path = "sbin/growfs";
  extraPaths = [
    "sbin/mount"
  ];

  buildInputs = [
    libufs
    libutil
  ];

  outputs = [
    "out"
    "man"
    "debug"
  ];

  MK_TESTS = "no";

  meta.mainProgram = "growfs";
  meta.platforms = lib.platforms.freebsd;
}
