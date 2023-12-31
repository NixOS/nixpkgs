{ mkDerivation, buildPackages, buildFreebsd, lib, stdenv, ... }:
mkDerivation {
  path = "usr.bin/localedef";

  extraPaths = [ "lib/libc/locale" "lib/libc/stdtime" "include" ];

  nativeBuildInputs = (with buildPackages; [
    bsdSetupHook
    byacc
  ]) ++ (with buildFreebsd; [
    freebsdSetupHook
    bmakeMinimal install
  ]);

  preBuild = lib.optionalString stdenv.cc.isClang ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -D_VA_LIST -D_VA_LIST_DECLARED -Dva_list=__builtin_va_list -D_SIZE_T -D_WCHAR_T"
  '' + lib.optionalString (!stdenv.hostPlatform.isFreeBSD) ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I $src/usr.bin/localedef/bootstrap"
  '';

  MK_TESTS = "no";
}
