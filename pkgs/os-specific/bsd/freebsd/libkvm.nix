{ mkDerivation, libc, libelf, ...}:
mkDerivation {
  path = "lib/libkvm";
  extraPaths = ["sys"];
  buildInputs = [libc libelf];
  MK_TESTS = "no";
}
