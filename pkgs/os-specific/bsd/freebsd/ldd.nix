{ mkDerivation, libelf, ... }:
mkDerivation {
  path = "usr.bin/ldd";
  extraPaths = ["libexec/rtld-elf" "contrib/elftoolchain/libelf"];

  buildInputs = [libelf];
}
