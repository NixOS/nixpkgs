{ mkDerivation, lib, stdenv, openssl, libradius, ... }:
mkDerivation {
  path = "lib/libpam/libpam";
  extraPaths = ["lib/libpam" "contrib/openpam" "lib/Makefile.inc" "contrib/pam_modules" "crypto/openssh"];
  buildInputs = [libradius openssl];

  MK_NIS = "no"; # TODO

  # TODO
  postPatch = ''
    sed -E -i -e /pam_tacplus/d $BSDSRCDIR/lib/libpam/modules/modules.inc
    sed -E -i -e /pam_krb5/d $BSDSRCDIR/lib/libpam/modules/modules.inc
    sed -E -i -e /pam_ksu/d $BSDSRCDIR/lib/libpam/modules/modules.inc
    sed -E -i -e /pam_ssh/d $BSDSRCDIR/lib/libpam/modules/modules.inc
  '';

  preBuild = lib.optionalString stdenv.cc.isClang ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -D_VA_LIST -D_VA_LIST_DECLARED -Dva_list=__builtin_va_list -D_SIZE_T_DECLARED -D_SIZE_T -Dsize_t=__SIZE_TYPE__ -D_WCHAR_T"
  '' + ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I$BSDSRCDIR/lib/libpam/libpam"
  '';

  MK_TESTS = "no";

  postInstall = ''
    make $makeFlags installconfig

    export NIX_LDFLAGS="$NIX_LDFLAGS -L$out/lib"
    make -C $BSDSRCDIR/lib/libpam/modules $makeFlags
    make -C $BSDSRCDIR/lib/libpam/modules $makeFlags install
    make -C $BSDSRCDIR/lib/libpam/modules $makeFlags installconfig
  '';
}
