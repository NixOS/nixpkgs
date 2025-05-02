{ lib, stdenv, mkDerivation, writeShellScript
, freebsd-lib
, mtree
, bsdSetupHook, freebsdSetupHook
, makeMinimal, mandoc, groff
, boot-install, install
, compatIfNeeded, libmd, libnetbsd
}:

# HACK: to ensure parent directories exist. This emulates GNU
# install’s -D option. No alternative seems to exist in BSD install.
let
  binstall = writeShellScript "binstall" (freebsd-lib.install-wrapper + ''

    @out@/bin/xinstall "''${args[@]}"
  '');
in mkDerivation {
  path = "usr.bin/xinstall";
  extraPaths = [ mtree.path ];
  nativeBuildInputs = [
    bsdSetupHook freebsdSetupHook
    makeMinimal mandoc groff
    (if stdenv.hostPlatform == stdenv.buildPlatform
     then boot-install
     else install)
  ];
  skipIncludesPhase = true;
  buildInputs = compatIfNeeded ++ [ libmd libnetbsd ];
  makeFlags = [
    "STRIP=-s" # flag to install, not command
    "MK_WERROR=no"
    "TESTSDIR=${builtins.placeholder "test"}"
  ] ++ lib.optional (stdenv.hostPlatform == stdenv.buildPlatform) "INSTALL=boot-install";
  postInstall = ''
    install -D -m 0550 ${binstall} $out/bin/binstall
    substituteInPlace $out/bin/binstall --subst-var out
    mv $out/bin/install $out/bin/xinstall
    ln -s ./binstall $out/bin/install
  '';
  outputs = [ "out" "man" "test" ];
}
