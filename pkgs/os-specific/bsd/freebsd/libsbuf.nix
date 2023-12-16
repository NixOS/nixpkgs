{ mkDerivation, stdenv, lib, compatIfNeeded, ...}:
mkDerivation {
  path = "lib/libsbuf";
  extraPaths = ["sys/kern"];
  buildInputs = compatIfNeeded;
  MK_TESTS = "no";
  preBuild = lib.optionalString stdenv.isFreeBSD ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -D_VA_LIST -D_VA_LIST_DECLARED -Dva_list=__builtin_va_list -D_SIZE_T -D_WCHAR_T"
  '';
}
