{
  mkDerivation,
  writeShellScript,
  mtree,
  make,
  bsdSetupHook,
  netbsdSetupHook,
  makeMinimal,
  mandoc,
  groff,
  rsync,
  compatIfNeeded,
  fts,

}:

# HACK: to ensure parent directories exist. This emulates GNU
# install’s -D option. No alternative seems to exist in BSD install.
let
  binstall = writeShellScript "binstall" (
    builtins.readFile ../../../lib/install-wrapper.sh
    + ''
      @out@/bin/xinstall "''${args[@]}"
    ''
  );
in
mkDerivation {
  path = "usr.bin/xinstall";
  version = "9.2";
  sha256 = "1f6pbz3qv1qcrchdxif8p5lbmnwl8b9nq615hsd3cyl4avd5bfqj";
  extraPaths = [
    mtree.src
    make.src
  ];
  nativeBuildInputs = [
    bsdSetupHook
    netbsdSetupHook
    makeMinimal
    mandoc
    groff
    rsync
  ];
  skipIncludesPhase = true;
  buildInputs =
    compatIfNeeded
    # fts header is needed. glibc already has this header, but musl doesn't,
    # so make sure pkgsMusl.netbsd.install still builds in case you want to
    # remove it!
    ++ [ fts ];
  installPhase = ''
    runHook preInstall

    install -D install.1 $out/share/man/man1/install.1
    install -D xinstall $out/bin/xinstall
    install -D -m 0550 ${binstall} $out/bin/binstall
    substituteInPlace $out/bin/binstall --subst-var out
    ln -s $out/bin/binstall $out/bin/install

    runHook postInstall
  '';
  setupHook = ./install-setup-hook.sh;
}
