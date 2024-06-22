{
  lib,
  mkDerivation,
  defaultMakeFlags,
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
  rpcgen,
  csu,
  headers,
}:

mkDerivation {
  noLibc = true;
  path = "lib/libc";
  pname = "libcMinimal-netbsd";
  outputs = [
    "out"
    "dev"
    "man"
    "tags"
  ];
  USE_FORT = "yes";
  MKPROFILE = "no";
  extraPaths = [
    "common"
    "lib/i18n_module"
    "libexec/ld.elf_so"
    "sys"
    "external/bsd/jemalloc"
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
    find include -type d -exec mkdir -p "$dev/{}" ';'
    find include '(' -type f -o -type l ')' -exec cp -pr "{}" "$dev/{}" ';'
    popd

    pushd ${csu}
    find lib -type d -exec mkdir -p "$out/{}" ';'
    find lib '(' -type f -o -type l ')' -exec cp -pr "{}" "$out/{}" ';'
    popd

    moveToOutput var/db/libc.tags "$tags"
  '';

  postPatch = ''
    sed -i 's,/usr\(/include/sys/syscall.h\),${headers}\1,g' lib/lib*/sys/Makefile.inc
  '';
}
