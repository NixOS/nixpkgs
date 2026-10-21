{ mkDerivation }:
mkDerivation {
  path = "usr.bin/kdump";
  extraPaths = [
    "sys"
    "usr.bin/ktrace"
  ];
}
