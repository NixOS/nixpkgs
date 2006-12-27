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
export shell=@shell@
param1=@param1@
param2=@param2@
param3=@param3@
param4=@param4@
param5=@param5@
if test -n "@preHook@"; then
    source @preHook@
fi


# Check that the pre-hook initialised SHELL.
if test -z "$SHELL"; then echo "SHELL not set"; exit 1; fi


# Hack: run gcc's setup hook.
envHooks=()
if test -f $NIX_GCC/nix-support/setup-hook; then
    source $NIX_GCC/nix-support/setup-hook
fi

    
# Ensure that the given directory exists.
ensureDir() {
    local dir=$1
    if ! test -x "$dir"; then mkdir -p "$dir"; fi
}


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
eval "$addInputsHook"


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
        source $pkg/nix-support/setup-hook
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
    export NIX_CFLAGS_STRIP="-g0 -Wl,--strip-debug"
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
    source @postHook@
fi

PATH=$_PATH${_PATH:+:}$PATH
if test "$NIX_DEBUG" = "1"; then
    echo "Final path: $PATH"
fi


######################################################################
# Textual substitution functions.


substitute() {
    local input="$1"
    local output="$2"

    local params=("$@")

    local sedScript=$NIX_BUILD_TOP/.sedargs
    rm -f $sedScript
    touch $sedScript

    local n p pattern replacement varName
    
    for ((n = 2; n < ${#params[*]}; n += 1)); do
        p=${params[$n]}

        if test "$p" = "--replace"; then
            pattern=${params[$((n + 1))]}
            replacement=${params[$((n + 2))]}
            n=$((n + 2))
            echo "s^$pattern^$replacement^g" >> $sedScript
            sedArgs=("${sedArgs[@]}" "-e" )
        fi

        if test "$p" = "--subst-var"; then
            varName=${params[$((n + 1))]}
            n=$((n + 1))
            echo "s^@${varName}@^${!varName}^g" >> $sedScript
        fi

        if test "$p" = "--subst-var-by"; then
            varName=${params[$((n + 1))]}
            replacement=${params[$((n + 2))]}
            n=$((n + 2))
            echo "s^@${varName}@^$replacement^g" >> $sedScript
        fi

    done

    sed -f $sedScript < "$input" > "$output".tmp
    if test -x "$output"; then
        chmod +x "$output".tmp
    fi
    mv -f "$output".tmp "$output"
}


substituteInPlace() {
    local fileName="$1"
    shift
    substitute "$fileName" "$fileName" "$@"
}


substituteAll() {
    local input="$1"
    local output="$2"
    
    # Select all environment variables that start with a lowercase character.
    for envVar in $(env | sed "s/^[^a-z].*//" | sed "s/^\([^=]*\)=.*/\1/"); do
        if test "$NIX_DEBUG" = "1"; then
            echo "$envVar -> ${!envVar}"
        fi
        args="$args --subst-var $envVar"
    done

    substitute "$input" "$output" $args
}  


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
            startLogWrite "$logDir/$logFile" "$logFifo"
            exec > $logFifo 2>&1
        else
            exec > $logDir/$logFile 2>&1
        fi
    fi
}

# Factored into a separate function so that it can be overriden.
startLogWrite() {
    tee "$1" < "$2" &
    logWriterPid=$!
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
        if test -n "$logWriterPid"; then
            wait $logWriterPid
            logWriterPid=
            rm $logFifo
        fi
    fi
}


# Utility function: return the base name of the given path, with the
# prefix `HASH-' removed, if present.
stripHash() {
    strippedName=$(basename $1);
    if echo "$strippedName" | grep -q '^[a-z0-9]\{32\}-'; then
        strippedName=$(echo "$strippedName" | cut -c34-)
    fi
}


unpackFile() {
    local file=$1
    local cmd

    header "unpacking source archive $file" 3

    case $file in
        *.tar)
            tar xvf $file || fail
            ;;
        *.tar.gz | *.tgz | *.tar.Z)
            gunzip < $file | tar xvf - || fail
            ;;
        *.tar.bz2 | *.tbz2)
            bunzip2 < $file | tar xvf - || fail
            ;;
        *.zip)
            unzip $file || fail
            ;;
        *)
            if test -d "$file"; then
                stripHash $file
                cp -prvd $file $strippedName || fail
            else
                if test -n "$findUnpacker"; then
                    $findUnpacker $1;
                fi
                if test -z "$unpackCmd"; then
                    echo "source archive $file has unknown type"
                    exit 1
                fi
                $unpackCmd || fail
            fi
            ;;
    esac

    stopNest
}


unpackW() {
    if test -n "$unpackPhase"; then
        eval "$unpackPhase"
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
        eval "$setSourceRoot"
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

    eval "$postUnpack"
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
        eval "$patchPhase"
        return
    fi

    if test -z "$patchFlags"; then
        patchFlags="-p1"
    fi

    for i in $patches; do
        header "applying patch $i" 3
        local uncompress=cat
        case $i in
            *.gz)
                uncompress=gunzip
                ;;
            *.bz2)
                uncompress=bunzip2
                ;;
        esac
        $uncompress < $i | patch $patchFlags || fail
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
        eval "$configurePhase"
        return
    fi

    eval "$preConfigure"

    if test -z "$prefix"; then
        prefix="$out";
    fi

    if test "$useTempPrefix" = "1"; then
        prefix="$NIX_BUILD_TOP/tmp_prefix";
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

    if test -z "$dontAddPrefix"; then
        configureFlags="--prefix=$prefix $configureFlags"
    fi

    echo "configure flags: $configureFlags ${configureFlagsArray[@]}"
    $configureScript $configureFlags"${configureFlagsArray[@]}" || fail

    eval "$postConfigure"
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
        eval "$buildPhase"
        return
    fi

    eval "$preBuild"
    
    echo "make flags: $makeFlags ${makeFlagsArray[@]} $buildFlags ${buildFlagsArray[@]}"
    make \
        $makeFlags "${makeFlagsArray[@]}" \
        $buildFlags "${buildFlagsArray[@]}" || fail

    eval "$postBuild"
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
        eval "$checkPhase"
        return
    fi

    if test -z "$checkTarget"; then
        checkTarget="check"
    fi

    echo "check flags: $makeFlags ${makeFlagsArray[@]} $checkFlags ${checkFlagsArray[@]}"
    make \
        $makeFlags ${makeFlagsArray[@]} \
        $checkFlags "${checkFlagsArray[@]}" $checkTarget || fail
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


patchELF() {
    # Patch all ELF executables and shared libraries.
    header "patching ELF executables and libraries"
    find "$prefix" \( \
        \( -type f -a -name "*.so*" \) -o \
        \( -type f -a -perm +0100 \) \
        \) -print -exec patchelf --shrink-rpath {} \;
    stopNest
}


installW() {
    if test -n "$installPhase"; then
        eval "$installPhase"
        return
    fi

    eval "$preInstall"

    ensureDir "$prefix"

    if test -z "$installCommand"; then
        if test -z "$dontMakeInstall"; then
            if test -z "$installTargets"; then
                installTargets=install
            fi
            echo "install flags: $installTargets $makeFlags ${makeFlagsArray[@]} $installFlags ${installFlagsArray[@]}"
            make $installTargets \
                $makeFlags ${makeFlagsArray[@]} \
                $installFlags "${installFlagsArray[@]}" || fail
        fi
    else
        eval "$installCommand"
    fi

    eval "$postInstall"
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


# The fixup phase performs generic, package-independent, Nix-related
# stuff, like running patchelf and setting the
# propagated-build-inputs.  It should rarely be overriden.
fixupW() {
    if test -n "$fixupPhase"; then
        eval "$fixupPhase"
        return
    fi

    eval "$preFixup"

    if test -z "$dontStrip" -a "$NIX_STRIP_DEBUG" = 1; then
        find "$prefix" -name "*.a" -exec echo stripping {} \; \
            -exec strip -S {} \; || fail
    fi

    if test "$havePatchELF" = 1 -a -z "$dontPatchELF"; then
        patchELF "$prefix"
    fi

    if test -n "$propagatedBuildInputs"; then
        ensureDir "$out/nix-support"
        echo "$propagatedBuildInputs" > "$out/nix-support/propagated-build-inputs"
    fi

    eval "$postFixup"
}


fixupPhase() {
    if test "$dontFixup" = 1; then
        return
    fi
    header "post-installation fixup"
    startLog "fixup"
    fixupW
    stopLog
    stopNest
}


distW() {
    if test -n "$distPhase"; then
        eval "$distPhase"
        return
    fi

    eval "$preDist"
    
    if test -z "$distTarget"; then
        distTarget="dist"
    fi

    echo "dist flags: $distFlags ${distFlagsArray[@]}"
    make $distFlags "${distFlagsArray[@]}" $distTarget || fail

    if test "$dontCopyDist" != 1; then
        ensureDir "$out/tarballs"

        if test -z "$tarballs"; then
            tarballs="*.tar.gz"
        fi

        # Note: don't quote $tarballs, since we explicitly permit
        # wildcards in there.
        cp -pvd $tarballs $out/tarballs
    fi

    eval "$postDist"
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

    if test -n "$buildCommand"; then
        eval "$buildCommand"
        return
    fi

    unpackPhase
    cd $sourceRoot

    if test -z "$phases"; then
        phases="patchPhase configurePhase buildPhase checkPhase \
            installPhase fixupPhase distPhase";
    fi

    for i in $phases; do
        dumpVars
        eval "$i"
    done
    
    stopNest
}


dumpVars
