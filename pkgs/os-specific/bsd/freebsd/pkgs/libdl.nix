{ mkDerivation, ... }:
mkDerivation {
  path = "lib/libdl";
  extraPaths = [
    "lib/libc"
    "libexec/rtld-elf"
  ];
  buildInputs = [ ];
}
