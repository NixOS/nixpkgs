set -e

test -z $NIX_GCC && NIX_GCC=@gcc@


# Set up the initial path.
PATH=
for i in $NIX_GCC @initialPath@; do
    PATH=$PATH${PATH:+:}$i/bin
done

if test "$NIX_DEBUG" = "1"; then
    echo "Initial path: $PATH"
fi


# Execute the pre-hook.
export SHELL=@shell@
param1=@param1@
param2=@param2@
param3=@param3@
param4=@param4@
param5=@param5@
if test -n "@preHook@"; then
    . @preHook@
fi


# Check that the pre-hook initialised SHELL.
if test -z "$SHELL"; then echo "SHELL not set"; exit 1; fi


# Hack: run gcc's setup hook.
envHooks=()
if test -f $NIX_GCC/nix-support/setup-hook; then
    . $NIX_GCC/nix-support/setup-hook
fi

    
# Called when some build action fails.  If $succeedOnFailure is set,
# create the file `$out/nix-support/failed' to signal failure, and
# exit normally.  Otherwise, exit with failure.
fail() {
    exitCode=$?
    if test "$succeedOnFailure" = 1; then
        ensureDir "$out/nix-support"
        touch "$out/nix-support/failed"
        exit 0
    else
        exit $?
    fi
}


# Allow the caller to augment buildInputs (it's not always possible to
# do this before the call to setup.sh, since the PATH is empty at that
# point; here we have a basic Unix environment).
if test -n "$addInputsHook"; then
    $addInputsHook
fi


# Recursively find all build inputs.
findInputs()
{
    local pkg=$1

    case $pkgs in
        *\ $pkg\ *)
            return 0
            ;;
    esac
    
    pkgs="$pkgs $pkg "

    if test -f $pkg/nix-support/setup-hook; then
        . $pkg/nix-support/setup-hook
    fi
    
    if test -f $pkg/nix-support/propagated-build-inputs; then
        for i in $(cat $pkg/nix-support/propagated-build-inputs); do
            findInputs $i
        done
    fi
}

pkgs=""
if test -n "$buildinputs"; then
    buildInputs="$buildinputs" # compatibility
fi
for i in $buildInputs $propagatedBuildInputs; do
    findInputs $i
done


# Set the relevant environment variables to point to the build inputs
# found above.
addToEnv()
{
    local pkg=$1

    if test "$ignoreFailedInputs" != "1" -a -e $1/nix-support/failed; then
        echo "failed input $1" >&2
        fail
    fi

    if test -d $1/bin; then
        export _PATH=$_PATH${_PATH:+:}$1/bin
    fi

    for i in "${envHooks[@]}"; do
        $i $pkg
    done
}

for i in $pkgs; do
    addToEnv $i
done


# Add the output as an rpath.
if test "$NIX_NO_SELF_RPATH" != "1"; then
    export NIX_LDFLAGS="-rpath $out/lib $NIX_LDFLAGS"
fi


# Strip debug information by default.
if test -z "$NIX_STRIP_DEBUG"; then
    export NIX_STRIP_DEBUG=1
    export NIX_CFLAGS_STRIP="-g0 -Wl,-s"
fi    


# Do we know where the store is?  This is required for purity checking.
if test -z "$NIX_STORE"; then
    echo "Error: you have an old version of Nix that does not set the" \
        "NIX_STORE variable.  Please upgrade." >&2
    exit 1
fi


# We also need to know the root of the build directory for purity checking.
if test -z "$NIX_BUILD_TOP"; then
    echo "Error: you have an old version of Nix that does not set the" \
        "NIX_BUILD_TOP variable.  Please upgrade." >&2
    exit 1
fi


# Set the TZ (timezone) environment variable, otherwise commands like
# `date' will complain (e.g., `Tue Mar 9 10:01:47 Local time zone must
# be set--see zic manual page 2004').
export TZ=UTC


# Execute the post-hook.
if test -n "@postHook@"; then
    . @postHook@
fi

PATH=$_PATH${_PATH:+:}$PATH
if test "$NIX_DEBUG" = "1"; then
    echo "Final path: $PATH"
fi


######################################################################
# What follows is the generic builder.


nestingLevel=0

startNest() {
    nestingLevel=$(($nestingLevel + 1))
    echo -en "\e[$1p"
}

stopNest() {
    nestingLevel=$(($nestingLevel - 1))
    echo -en "\e[q"
}

header() {
    startNest "$2"
    echo "$1"
}

# Make sure that even when we exit abnormally, the original nesting
# level is properly restored.
closeNest() {
    while test $nestingLevel -gt 0; do
        stopNest
    done
}

trap "closeNest" EXIT


# This function is useful for debugging broken Nix builds.  It dumps
# all environment variables to a file `env-vars' in the build
# directory.  If the build fails and the `-K' option is used, you can
# then go to the build directory and source in `env-vars' to reproduce
# the environment used for building.
dumpVars() {
    if test "$noDumpEnvVars" != "1"; then
        export > $NIX_BUILD_TOP/env-vars
    fi
}


# Ensure that the given directory exists.
ensureDir() {
    local dir=$1
    if ! test -x "$dir"; then mkdir -p "$dir"; fi
}


# Redirect stdout/stderr to a named pipe connected to a `tee' process
# that writes the specified file (and also to our original stdout).
# The original stdout is saved in descriptor 3.
startLog() {
    local logFile=${logNr}_$1
    logNr=$((logNr + 1))
    if test "$logPhases" = 1; then
        ensureDir $logDir

        exec 3>&1

        if test "$dontLogThroughTee" != 1; then
            # This required named pipes (fifos).
            logFifo=$NIX_BUILD_TOP/log_fifo
            test -p $logFifo || mkfifo $logFifo
            tee $logDir/$logFile < $logFifo &
            logTeePid=$!
            exec > $logFifo 2>&1
        else
            exec > $logDir/$logFile 2>&1
        fi
    fi
}

if test -z "$logDir"; then
    logDir=$out/log
fi

logNr=0

# Restore the original stdout/stderr.
stopLog() {
    if test "$logPhases" = 1; then
        exec >&3 2>&1

        # Wait until the tee process has died.  Otherwise output from
        # different phases may be mixed up.
        if test -n "$logTeePid"; then
            wait $logTeePid
            logTeePid=
            rm $logFifo
        fi
    fi
}


# Utility function: return the base name of the given path, with the
# prefix `HASH-' removed, if present.
stripHash() {
    strippedName=$(basename $1);
    if echo "$strippedName" | grep -q '^[a-f0-9]\{32\}-'; then
        strippedName=$(echo "$strippedName" | cut -c34-)
    fi
}


unpackFile() {
    local file=$1
    local cmd

    case $file in
        *.tar) cmd="tar xvf $file";;
        *.tar.gz | *.tgz | *.tar.Z) cmd="tar xvfz $file";;
        *.tar.bz2 | *.tbz2) cmd="tar xvfj $file";;
        *.zip) cmd="unzip $file";;
        *)
            if test -d "$file"; then
                stripHash $file
                cmd="cp -prvd $file $strippedName"
            else
                if test -n "$findUnpacker"; then
                    $findUnpacker $1;
                fi
                if test -z "$unpackCmd"; then
                    echo "source archive $file has unknown type"
                    exit 1
                fi
                cmd=$unpackCmd
            fi
            ;;
    esac

    header "unpacking source archive $file (using $cmd)" 3
    $cmd || fail
    stopNest
}


unpackW() {
    if test -n "$unpackPhase"; then
        $unpackPhase
        return
    fi

    if test -z "$srcs"; then
        if test -z "$src"; then
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
        if test -d "$i"; then
            dirsBefore="$dirsBefore $i "
        fi
    done

    # Unpack all source archives.
    for i in $srcs; do
        unpackFile $i
    done

    # Find the source directory.
    if test -n "$setSourceRoot"; then
        $setSourceRoot
    else
        sourceRoot=
        for i in *; do
            if test -d "$i"; then
                case $dirsBefore in
                    *\ $i\ *)
                        ;;
                    *)
                        if test -n "$sourceRoot"; then
                            echo "unpacker produced multiple directories"
                            exit 1
                        fi
                        sourceRoot=$i
                        ;;
                esac
            fi
        done
    fi

    if test -z "$sourceRoot"; then
        echo "unpacker appears to have produced no directories"
        exit 1
    fi

    echo "source root is $sourceRoot"

    # By default, add write permission to the sources.  This is often
    # necessary when sources have been copied from other store
    # locations.
    if test "dontMakeSourcesWritable" != 1; then
        chmod -R +w $sourceRoot
    fi
    
    if test -n "$postUnpack"; then
        $postUnpack
    fi
}


unpackPhase() {
    header "unpacking sources"
    startLog "unpack"
    unpackW
    stopLog
    stopNest
}


patchW() {
    if test -n "$patchPhase"; then
        $patchPhase
        return
    fi

    for i in $patches; do
        header "applying patch $i" 3
        patch -p1 < $i || fail
        stopNest
    done
}


patchPhase() {
    if test -z "$patchPhase" -a -z "$patches"; then return; fi
    header "patching sources"
    startLog "patch"
    patchW
    stopLog
    stopNest
}


fixLibtool() {
    sed 's^eval sys_lib_.*search_path=.*^^' < $1 > $1.tmp
    mv $1.tmp $1
}


configureW() {
    if test -n "$configurePhase"; then
        $configurePhase
        return
    fi

    if test -n "$preConfigure"; then
        $preConfigure
    fi

    if test -z "$configureScript"; then
        configureScript=./configure
        if ! test -x $configureScript; then
            echo "no configure script, doing nothing"
            return
        fi
    fi

    if test -z "$dontFixLibtool"; then
        for i in $(find . -name "ltmain.sh"); do
            echo "fixing libtool script $i"
            fixLibtool $i
        done
    fi

    if test -z "$prefix"; then
        prefix="$out";
    fi

    if test "$useTempPrefix" = "1"; then
        prefix="$NIX_BUILD_TOP/tmp_prefix";
    fi

    if test -z "$dontAddPrefix"; then
        configureFlags="--prefix=$prefix $configureFlags"
    fi

    echo "configure flags: $configureFlags"
    $configureScript $configureFlags || fail

    if test -n "$postConfigure"; then
        $postConfigure
    fi
}


configurePhase() {
    header "configuring"
    startLog "configure"
    configureW
    stopLog
    stopNest
}


buildW() {
    if test -n "$buildPhase"; then
        $buildPhase
        return
    fi

    if test -n "$preBuild"; then
        $preBuild
    fi
    
    echo "make flags: $makeFlags"
    make $makeFlags || fail

    if test -n "$postBuild"; then
        $postBuild
    fi
}


buildPhase() {
    if test "$dontBuild" = 1; then
        return
    fi
    header "building"
    startLog "build"
    buildW
    stopLog
    stopNest
}


checkW() {
    if test -n "$checkPhase"; then
        $checkPhase
        return
    fi

    if test -z "$checkTarget"; then
        checkTarget="check"
    fi

    echo "check flags: $checkFlags"
    make $checkFlags $checkTarget || fail
}


checkPhase() {
    if test "$doCheck" != 1; then
        return
    fi
    header "checking"
    startLog "check"
    checkW
    stopLog
    stopNest
}


installW() {
    if test -n "$installPhase"; then
        $installPhase
        return
    fi
    
    if test -n "$preInstall"; then
        $preInstall
    fi

    ensureDir "$prefix"
    
    if test -z "$dontMakeInstall"; then
        echo "install flags: $installFlags"
        make install $installFlags || fail
    fi

    if test -z "$dontStrip" -a "$NIX_STRIP_DEBUG" = 1; then
        find "$prefix" -name "*.a" -exec echo stripping {} \; \
            -exec strip -S {} \; || fail
    fi

    if test -n "$propagatedBuildInputs"; then
        ensureDir "$out/nix-support"
        echo "$propagatedBuildInputs" > "$out/nix-support/propagated-build-inputs"
    fi

    if test -n "$postInstall"; then
        $postInstall
    fi
}


installPhase() {
    if test "$dontInstall" = 1; then
        return
    fi
    header "installing"
    startLog "install"
    installW
    stopLog
    stopNest
}


distW() {
    if test -n "$distPhase"; then
        $distPhase
        return
    fi

    if test -n "$preDist"; then
        $preDist
    fi
    
    if test -z "$distTarget"; then
        distTarget="dist"
    fi

    echo "dist flags: $distFlags"
    make $distFlags $distTarget || fail

    if test "$dontCopyDist" != 1; then
        ensureDir "$out/tarballs"

        if test -z "$tarballs"; then
            tarballs="*.tar.gz"
        fi

        # Note: don't quote $tarballs, since we explicitly permit
        # wildcards in there.
        cp -pvd $tarballs $out/tarballs
    fi

    if test -n "$postDist"; then
        $postDist
    fi
}


distPhase() {
    if test "$doDist" != 1; then
        return
    fi
    header "creating distribution"
    startLog "dist"
    distW
    stopLog
    stopNest
}


genericBuild() {
    header "building $out"

    unpackPhase
    cd $sourceRoot

    if test -z "$phases"; then
        phases="patchPhase configurePhase buildPhase checkPhase \
            installPhase distPhase";
    fi

    for i in $phases; do
        dumpVars
        $i
    done
    
    stopNest
}


dumpVars
