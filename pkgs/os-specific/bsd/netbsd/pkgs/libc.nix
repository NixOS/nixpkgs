{
  lib,
  mkDerivation,
  defaultMakeFlags,
  _mainLibcExtraPaths,
  fetchNetBSD,
  bsdSetupHook,
  netbsdSetupHook,
  makeMinimal,
  install,
  mandoc,
  groff,
  flex,
  byacc,
  genassym,
  gencat,
  lorder,
  tsort,
  statHook,
  rsync,
  rpcgen,
  csu,
  headers,
  librt,
}:

mkDerivation {
  path = "lib/libc";
  version = "9.2";
  sha256 = "1y9c13igg0kai07sqvf9cm6yqmd8lhfd8hq3q7biilbgs1l99as3";
  USE_FORT = "yes";
  MKPROFILE = "no";
  extraPaths = _mainLibcExtraPaths ++ [
    (fetchNetBSD "external/bsd/jemalloc" "9.2" "0cq704swa0h2yxv4gc79z2lwxibk9k7pxh3q5qfs7axx3jx3n8kb")
  ];
  nativeBuildInputs = [
    bsdSetupHook
    netbsdSetupHook
    makeMinimal
    install
    mandoc
    groff
    flex
    byacc
    genassym
    gencat
    lorder
    tsort
    statHook
    rsync
    rpcgen
  ];
  buildInputs = [
    headers
    csu
  ];
  env.NIX_CFLAGS_COMPILE = "-B${csu}/lib -fcommon";
  meta.platforms = lib.platforms.netbsd;
  SHLIBINSTALLDIR = "$(out)/lib";
  MKPICINSTALL = "yes";
  NLSDIR = "$(out)/share/nls";
  makeFlags = defaultMakeFlags ++ [ "FILESDIR=$(out)/var/db" ];
  postInstall = ''
    pushd ${headers}
    find . -type d -exec mkdir -p $out/\{} \;
    find . \( -type f -o -type l \) -exec cp -pr \{} $out/\{} \;
    popd

    pushd ${csu}
    find . -type d -exec mkdir -p $out/\{} \;
    find . \( -type f -o -type l \) -exec cp -pr \{} $out/\{} \;
    popd

    NIX_CFLAGS_COMPILE+=" -B$out/lib"
    NIX_CFLAGS_COMPILE+=" -I$out/include"
    NIX_LDFLAGS+=" -L$out/lib"

    make -C $BSDSRCDIR/lib/libpthread $makeFlags
    make -C $BSDSRCDIR/lib/libpthread $makeFlags install

    make -C $BSDSRCDIR/lib/libm $makeFlags
    make -C $BSDSRCDIR/lib/libm $makeFlags install

    make -C $BSDSRCDIR/lib/libresolv $makeFlags
    make -C $BSDSRCDIR/lib/libresolv $makeFlags install

    make -C $BSDSRCDIR/lib/librpcsvc $makeFlags
    make -C $BSDSRCDIR/lib/librpcsvc $makeFlags install

    make -C $BSDSRCDIR/lib/i18n_module $makeFlags
    make -C $BSDSRCDIR/lib/i18n_module $makeFlags install

    make -C $BSDSRCDIR/lib/libutil $makeFlags
    make -C $BSDSRCDIR/lib/libutil $makeFlags install

    make -C $BSDSRCDIR/lib/librt $makeFlags
    make -C $BSDSRCDIR/lib/librt $makeFlags install

    make -C $BSDSRCDIR/lib/libcrypt $makeFlags
    make -C $BSDSRCDIR/lib/libcrypt $makeFlags install
  '';
  inherit (librt) postPatch;
}
