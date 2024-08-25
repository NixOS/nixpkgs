{
  mkDerivation,
  bsdSetupHook,
  netbsdSetupHook,
  makeMinimal,
  install,
  tsort,
  lorder,
  mandoc,
  statHook,
  nbperf,
  tic,
  compatIfNeeded,
}:

mkDerivation {
  path = "lib/libterminfo";
  nativeBuildInputs = [
    bsdSetupHook
    netbsdSetupHook
    makeMinimal
    install
    tsort
    lorder
    mandoc
    statHook
    nbperf
    tic
  ];
  buildInputs = compatIfNeeded;
  SHLIBINSTALLDIR = "$(out)/lib";
  postPatch = ''
    substituteInPlace $COMPONENT_PATH/term.c --replace-fail /usr/share $out/share
    substituteInPlace $COMPONENT_PATH/setupterm.c \
      --replace-fail '#include <curses.h>' 'void use_env(bool);'
  '';
  postBuild = ''
    make -C $BSDSRCDIR/share/terminfo $makeFlags BINDIR=$out/share
  '';
  postInstall = ''
    make -C $BSDSRCDIR/share/terminfo $makeFlags BINDIR=$out/share install
  '';
  extraPaths = [ "share/terminfo" ];
}
