export IMAKECPP="@tradcpp@/bin/tradcpp"

imakeConfigurePhase() {
    runHook preConfigure

    echoCmd 'configuring with imake'

    if [ -z "${imakefile:-}" -a ! -e Imakefile ]; then
        echo "no Imakefile, doing nothing"
    else
        xmkmf -a
    fi

    runHook postConfigure
}

if [ -z "$dontUseImakeConfigure" -a -z "$configurePhase" ]; then
    configurePhase=imakeConfigurePhase
fi
