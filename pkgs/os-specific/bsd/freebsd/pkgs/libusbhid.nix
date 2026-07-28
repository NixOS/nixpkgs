{
  lib,
  mkDerivation,
}:
mkDerivation {
  path = "lib/libusbhid";

  outputs = [
    "out"
    "man"
    "debug"
  ];

  meta.platforms = lib.platforms.freebsd;
}
