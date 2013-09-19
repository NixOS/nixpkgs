source $stdenv/setup

export R_LIBS_SITE="$R_LIBS_SITE${R_LIBS_SITE:+:}$out/library"


if test -n "$rPreHook"; then
    eval "$rPreHook"
fi

installPhase() {
	runHook preInstall
	mkdir -p $out/library
	R CMD INSTALL -l $out/library $src
	runHook postInstall
}

postFixup() {
    if test -e $out/nix-support/propagated-native-build-inputs; then
        ln -s $out/nix-support/propagated-native-build-inputs $out/nix-support/propagated-user-env-packages
    fi
}

genericBuild
