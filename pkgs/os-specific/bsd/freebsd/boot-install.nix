{ install-wrapper, mkDerivation, mtree, buildPackages, buildFreebsd, compatIfNeeded, lib, stdenv, libmd, libnetbsd, ... }:
let binstall = buildPackages.writeShellScript "binstall" (install-wrapper + ''
  @out@/bin/xinstall "''${args[@]}"
''); in mkDerivation {
  pname = "xinstall-minimal";
  path = "usr.bin/xinstall";
  extraPaths = [ mtree.path ];
  nativeBuildInputs = [
    buildPackages.bsdSetupHook buildFreebsd.freebsdSetupHook
    buildFreebsd.makeMinimal buildPackages.mandoc buildPackages.groff  # TODO bmake??
    buildPackages.libmd
    #buildFreebsd.libnetbsd
  ];
  skipIncludesPhase = true;
  buildInputs = compatIfNeeded ++ [libmd libnetbsd];  # TODO: WHAT is up with pkgs.libmd and libnetbsd
  makeFlags = [
    "STRIP=-s" # flag to install, not command
    "MK_WERROR=no"
    "TESTSDIR=${builtins.placeholder "test"}"
  ] ++ lib.optional (stdenv.hostPlatform == stdenv.buildPlatform) "INSTALL=boot-install";
  installPhase = ''
    mkdir -p $out/bin
    cp $BSDSRDIR/usr.bin/xinstall/install $out/bin/xinstall
    cp ${binstall} $out/bin/binstall
    chmod +x $out/bin/binstall
    substituteInPlace $out/bin/binstall --subst-var out
    ln -s ./binstall $out/bin/install
  '';
  outputs = [ "out" ];
}
