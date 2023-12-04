{ mkDerivation, ...}:
mkDerivation {
  pname = "libcxxrt";
  path = "lib/libcxxrt";
  extraPaths = [
    "contrib/libcxxrt"
  ];
}
