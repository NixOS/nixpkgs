. $stdenv/setup

postInstall() {
    test -x $out/nix-support || mkdir $out/nix-support
    cp $setupHook $out/nix-support/setup-hook
}
postInstall=postInstall

genericBuild

