{
  lib,
  mkDerivation,
  include,
  bsdSetupHook,
  netbsdSetupHook,
  makeMinimal,
  install,
  tsort,
  lorder,
  statHook,
  uudecode,
  config,
  genassym,
  defaultMakeFlags,
}:
{
  path = "sys";

  # Make the build ignore linker warnings
  prePatch = ''
    substituteInPlace sys/conf/Makefile.kern.inc \
      --replace "-Wa,--fatal-warnings" ""
  '';

  patches = [
    # Fix this error when building bootia32.efi and bootx64.efi:
    # error: PHDR segment not covered by LOAD segment
    ./no-dynamic-linker.patch

    # multiple header dirs, see above
    ./sys-headers-incsdir.patch
  ];

  postPatch = ''
    substituteInPlace sys/arch/i386/stand/efiboot/Makefile.efiboot \
      --replace "-nocombreloc" "-z nocombreloc"
  ''
  +
    # multiple header dirs, see above
    include.postPatch;

  CONFIG = "GENERIC";

  propagatedBuildInputs = [ include ];
  nativeBuildInputs = [
    bsdSetupHook
    netbsdSetupHook
    makeMinimal
    install
    tsort
    lorder
    statHook
    uudecode
    config
    genassym
  ];

  postConfigure = ''
    pushd arch/$MACHINE/conf
    config $CONFIG
    popd
  ''
  # multiple header dirs, see above
  + include.postConfigure;

  makeFlags = defaultMakeFlags ++ [ "FIRMWAREDIR=$(out)/libdata/firmware" ];
  hardeningDisable = [ "pic" ];
  MKKMOD = "no";
  env.NIX_CFLAGS_COMPILE = toString [
    "-Wno-error=array-parameter"
    "-Wno-error=array-bounds"
    "-Wa,--no-warn"
  ];

  postBuild = ''
    make -C arch/$MACHINE/compile/$CONFIG $makeFlags
  '';

  postInstall = ''
    cp arch/$MACHINE/compile/$CONFIG/netbsd $out
  '';

  meta.platforms = lib.platforms.netbsd;
  extraPaths = [ "common" ];
}
