{ mkDerivation, libc, ...}:
mkDerivation {
  path = "lib/libnv";
  extraPaths = ["sys/contrib/libnv" "sys/sys"];
  buildInputs = [libc];
  MK_TESTS = "no";
}
