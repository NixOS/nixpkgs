{ install-wrapper, mkDerivation, mtree, buildPackages, buildFreebsd, compatIfNeeded, lib, stdenv, libmd, libnetbsd, ... }:
let binstall = buildPackages.writeShellScript "binstall" (install-wrapper + ''
  @out@/bin/xinstall "''${args[@]}"
''); in mkDerivation {
  path = "usr.bin/xinstall";
  extraPaths = [ mtree.path ];
  nativeBuildInputs = [
    buildPackages.bsdSetupHook buildFreebsd.freebsdSetupHook
    buildFreebsd.bmakeMinimal buildPackages.mandoc buildPackages.groff  # TODO bmake??
    (if stdenv.hostPlatform == stdenv.buildPlatform
     then buildFreebsd.boot-install
     else buildFreebsd.install)
    buildPackages.libmd
    buildFreebsd.libnetbsd
  ];
  skipIncludesPhase = true;
  buildInputs = compatIfNeeded ++ [libmd libnetbsd];
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
