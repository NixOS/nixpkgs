{ mkDerivation, lib, stdenv, login, ... }:
mkDerivation {
  path = "libexec/getty";

  postPatch = ''
    sed -E -i -e "s|/usr/bin/login|${login}/bin/login|g" $BSDSRCDIR/libexec/getty/*.h
  '';

  preBuild = lib.optionalString stdenv.cc.isClang ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -D_VA_LIST -D_VA_LIST_DECLARED -Dva_list=__builtin_va_list -D_SIZE_T -D_WCHAR_T"
  '';

  MK_TESTS = "no";

  postInstall = ''
    mkdir -p $out/etc
    cp $BSDSRCDIR/libexec/getty/gettytab $out/etc/gettytab
  '';
}
