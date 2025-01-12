{
  lib,
  stdenv,
  mkDerivation,
  writeShellScript,
  freebsd-lib,
  bsdSetupHook,
  freebsdSetupHook,
  makeMinimal,
  mandoc,
  groff,
  boot-install,
  install,
  compatIfNeeded,
  libmd,
  libnetbsd,
}:

# HACK: to ensure parent directories exist. This emulates GNU
# install’s -D option. No alternative seems to exist in BSD install.
let
  binstall = writeShellScript "binstall" (
    freebsd-lib.install-wrapper
    + ''

      @out@/bin/xinstall "''${args[@]}"
    ''
  );
  libmd' = libmd.override {
    bootstrapInstallation = true;
  };
in
mkDerivation {
  path = "usr.bin/xinstall";
  extraPaths = [ "contrib/mtree" ];
  nativeBuildInputs = [
    bsdSetupHook
    freebsdSetupHook
    makeMinimal
    mandoc
    groff
    (if stdenv.hostPlatform == stdenv.buildPlatform then boot-install else install)
  ];
  skipIncludesPhase = true;
  buildInputs =
    compatIfNeeded
    ++ lib.optionals (!stdenv.hostPlatform.isFreeBSD) [
      libmd'
    ]
    ++ [
      libnetbsd
    ];
  makeFlags =
    [
      "STRIP=-s" # flag to install, not command
      "MK_WERROR=no"
      "TESTSDIR=${builtins.placeholder "test"}"
    ]
    ++ lib.optionals (stdenv.hostPlatform == stdenv.buildPlatform) [
      "BOOTSTRAPPING=1"
      "INSTALL=boot-install"
    ];
  postInstall = ''
    install -C -m 0550 ${binstall} $out/bin/binstall
    substituteInPlace $out/bin/binstall --subst-var out
    mv $out/bin/install $out/bin/xinstall
    ln -s ./binstall $out/bin/install
  '';
  outputs = [
    "out"
    "man"
    "test"
  ];
}
