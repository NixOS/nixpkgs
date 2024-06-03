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
  rsync,
  compatIfNeeded,
  fetchNetBSD,
}:

mkDerivation {
  path = "lib/libterminfo";
  version = "9.2";
  sha256 = "0pq05k3dj0dfsczv07frnnji92mazmy2qqngqbx2zgqc1x251414";
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
    rsync
  ];
  buildInputs = compatIfNeeded;
  SHLIBINSTALLDIR = "$(out)/lib";
  postPatch = ''
    substituteInPlace $COMPONENT_PATH/term.c --replace /usr/share $out/share
    substituteInPlace $COMPONENT_PATH/setupterm.c \
      --replace '#include <curses.h>' 'void use_env(bool);'
  '';
  postBuild = ''
    make -C $BSDSRCDIR/share/terminfo $makeFlags BINDIR=$out/share
  '';
  postInstall = ''
    make -C $BSDSRCDIR/share/terminfo $makeFlags BINDIR=$out/share install
  '';
  extraPaths = [
    (fetchNetBSD "share/terminfo" "9.2" "1vh9rl4w8118a9qdpblfxmv1wkpm83rm9gb4rzz5bpm56i6d7kk7")
  ];
}
