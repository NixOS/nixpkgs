{ pkgs, install-wrapper, mkDerivation, mtree, buildPackages, compatIfNeeded, lib, stdenv, libnetbsd }:
let binstall = pkgs.writeShellScript "binstall" (install-wrapper + ''
  @out@/bin/xinstall "''${args[@]}"
''); in mkDerivation {
  path = "usr.bin/xinstall";
  extraPaths = [ mtree.path ];
  nativeBuildInputs = with buildPackages.freebsd; [
    pkgs.bsdSetupHook freebsdSetupHook
    makeMinimal pkgs.mandoc pkgs.groff
    (if stdenv.hostPlatform == stdenv.buildPlatform
     then boot-install
     else install)
  ];
  skipIncludesPhase = true;
  buildInputs = compatIfNeeded ++ [ pkgs.libmd libnetbsd ];
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
