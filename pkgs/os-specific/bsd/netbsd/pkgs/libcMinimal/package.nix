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

  patches = [
    # https://mail-index.netbsd.org/tech-toolchain/2024/06/24/msg004438.html
    #
    # The patch is vendored because the archive software inlined my
    # attachment so I am not sure how to programmatically download it.
    ./0001-Allow-building-libc-without-generating-tags.patch
  ];

  nativeBuildInputs = [
    bsdSetupHook
    netbsdSetupHook
    makeMinimal
    install
    tsort
    lorder
    mandoc
    groff
    statHook
    flex
    byacc
    gencat
  ];

  buildInputs = [
    headers
    csu
  ];

  env.NIX_CFLAGS_COMPILE = "-B${csu}/lib -fcommon";

  SHLIBINSTALLDIR = "$(out)/lib";
  MKPICINSTALL = "yes";
  MK_LIBC_TAGS = "no";
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
  '';

  postPatch = ''
    sed -i 's,/usr\(/include/sys/syscall.h\),${headers}\1,g' lib/lib*/sys/Makefile.inc
  '';

  meta.platforms = lib.platforms.netbsd;
}
