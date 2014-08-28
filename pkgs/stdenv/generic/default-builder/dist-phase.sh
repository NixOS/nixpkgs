
distPhase() {
    runHook preDist

    echo "dist flags: $distFlags ${distFlagsArray[@]}"
    make ${makefile:+-f $makefile} $distFlags "${distFlagsArray[@]}" ${distTarget:-dist}

    if [ "$dontCopyDist" != 1 ]; then
        mkdir -p "$out/tarballs"

        # Note: don't quote $tarballs, since we explicitly permit
        # wildcards in there.
        cp -pvd ${tarballs:-*.tar.gz} $out/tarballs
    fi

    runHook postDist
}

