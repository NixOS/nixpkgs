######################################################################
# unpack and patch phases

unpackCmdHooks+=(_defaultUnpack)

_defaultUnpack() {
    local fn="$1"

    if [ -d "$fn" ]; then

        stripHash "$fn"
        cp -prd --no-preserve=timestamps "$fn" $strippedName

    else

        case "$fn" in
            *.tar.xz | *.tar.lzma)
                # Don't rely on tar knowing about .xz.
                xz -d < "$fn" | tar xf -
                ;;
            *.tar | *.tar.* | *.tgz | *.tbz2)
                # GNU tar can automatically select the decompression method
                # (info "(tar) gzip").
                tar xf "$fn"
                ;;
            *)
                return 1
                ;;
        esac

    fi
}


unpackFile() {
    curSrc="$1"
    header "unpacking source archive $curSrc" 3
    if ! runOneHook unpackCmd "$curSrc"; then
        echo "do not know how to unpack source archive $curSrc"
        exit 1
    fi
    stopNest
}


unpackPhase() {
    runHook preUnpack

    if [ -z "$srcs" ]; then
        if [ -z "$src" ]; then
            echo 'variable $src or $srcs should point to the source'
            exit 1
        fi
        srcs="$src"
    fi

    # To determine the source directory created by unpacking the
    # source archives, we record the contents of the current
    # directory, then look below which directory got added.  Yeah,
    # it's rather hacky.
    local dirsBefore=""
    for i in *; do
        if [ -d "$i" ]; then
            dirsBefore="$dirsBefore $i "
        fi
    done

    # Unpack all source archives.
    for i in $srcs; do
        unpackFile $i
    done

    # Find the source directory.
    if [ -n "$setSourceRoot" ]; then
        runOneHook setSourceRoot
    elif [ -z "$sourceRoot" ]; then
        sourceRoot=
        for i in *; do
            if [ -d "$i" ]; then
                case $dirsBefore in
                    *\ $i\ *)
                        ;;
                    *)
                        if [ -n "$sourceRoot" ]; then
                            echo "unpacker produced multiple directories"
                            exit 1
                        fi
                        sourceRoot="$i"
                        ;;
                esac
            fi
        done
    fi

    if [ -z "$sourceRoot" ]; then
        echo "unpacker appears to have produced no directories"
        exit 1
    fi

    echo "source root is $sourceRoot"

    # By default, add write permission to the sources.  This is often
    # necessary when sources have been copied from other store
    # locations.
    if [ "$dontMakeSourcesWritable" != 1 ]; then
        chmod -R u+w "$sourceRoot"
    fi

    runHook postUnpack
}


patchPhase() {
    runHook prePatch

    for i in $patches; do
        header "applying patch $i" 3
        local uncompress=cat
        case $i in
            *.gz)
                uncompress="gzip -d"
                ;;
            *.bz2)
                uncompress="bzip2 -d"
                ;;
            *.xz)
                uncompress="xz -d"
                ;;
            *.lzma)
                uncompress="lzma -d"
                ;;
        esac
        # "2>&1" is a hack to make patch fail if the decompressor fails (nonexistent patch, etc.)
        $uncompress < $i 2>&1 | patch ${patchFlags:--p1}
        stopNest
    done

    runHook postPatch
}

