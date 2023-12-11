{ mkDerivation, libc, ...}:
mkDerivation {
  path = "lib/libdl";
  extraPaths = ["lib/libc" "libexec/rtld-elf"];
  buildInputs = [];
  preBuild = ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -D_VA_LIST_DECLARED -D_SIZE_T"
  '';
}
