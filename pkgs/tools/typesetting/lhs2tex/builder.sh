source $stdenv/setup

postInstall() {

    ensureDir "$out/share/doc/$name"
    cp doc/Guide2.pdf $out/share/doc/$name
    ensureDir "$out/nix-support"
    echo "$propagatedUserEnvPackages" > $out/nix-support/propagated-user-env-packages

}

postInstall=postInstall

genericBuild
