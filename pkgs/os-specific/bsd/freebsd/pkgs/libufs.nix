{ mkDerivation }:
mkDerivation {
  path = "lib/libufs";
  extraPaths = [
    "sys/libkern"
    "sys/ufs"
  ];
}
