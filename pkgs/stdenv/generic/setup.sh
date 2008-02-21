######################################################################
# Helper functions that might be useful in setup hooks.


addToSearchPathWithCustomDelimiter() {
    local delimiter=$1
    local varName=$2
    local needDir=$3
    local addDir=${4:-$needDir}
    local prefix=$5
    if [ -d $prefix$needDir ]; then
        if [ -z ${!varName} ]; then
            eval export ${varName}=${prefix}$addDir
        else
            eval export ${varName}=${!varName}${delimiter}${prefix}$addDir
        fi
    fi
}

addToSearchPath()
{
    addToSearchPathWithCustomDelimiter "${PATH_DELIMITER}" "$@"
}


######################################################################
# Initialisation.

set -e

test -z $NIX_GCC && NIX_GCC=@gcc@


# Set up the initial path.
PATH=
for i in $NIX_GCC @initialPath@; do
    PATH=$PATH${PATH:+:}$i/bin
done

if test "$NIX_DEBUG" = "1"; then
    echo "initial path: $PATH"
fi


# Execute the pre-hook.
export SHELL=@shell@
PATH_DELIMITER=':'
if test -z "$shell"; then
    export shell=@shell@
fi
param1=@param1@
param2=@param2@
param3=@param3@
param4=@param4@
param5=@param5@
if test -n "@preHook@"; then source @preHook@; fi
eval "$preHook"


# Check that the pre-hook initialised SHELL.
if test -z "$SHELL"; then echo "SHELL not set"; exit 1; fi


# Hack: run gcc's setup hook.
envHooks=()
if test -f $NIX_GCC/nix-support/setup-hook; then
    source $NIX_GCC/nix-support/setup-hook
fi


# Ensure that the given directories exists.
ensureDir() {
    local dir
    for dir in "$@"; do
        if ! test -x "$dir"; then mkdir -p "$dir"; fi
    done
}

installBin() {
  ensureDir $out/bin
  cp "$@" $out/bin
}

assertEnvExists(){
  if test -z "${!1}"; then
      msg=${2:-error: assertion failed: env var $1 is required}
      echo $msg >&2; exit 1
  fi
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


assertEnvExists NIX_STORE \
    "Error: you have an old version of Nix that does not set the
     NIX_STORE variable. This is required for purity checking.
     Please upgrade."

assertEnvExists NIX_BUILD_TOP \
    "Error: you have an old version of Nix that does not set the
     NIX_BUILD_TOP variable. This is required for purity checking.
     Please upgrade."


# Set the TZ (timezone) environment variable, otherwise commands like
# `date' will complain (e.g., `Tue Mar 9 10:01:47 Local time zone must
# be set--see zic manual page 2004').
export TZ=UTC


# Set the prefix.  This is generally $out, but it can be overriden,
# for instance if we just want to perform a test build/install to a
# temporary location and write a build report to $out.
if test -z "$prefix"; then
    prefix="$out";
fi

if test "$useTempPrefix" = "1"; then
    prefix="$NIX_BUILD_TOP/tmp_prefix";
fi


PATH=$_PATH${_PATH:+:}$PATH
if test "$NIX_DEBUG" = "1"; then
    echo "final path: $PATH"
fi


######################################################################
# Misc. helper functions.


stripDirs() {
    local dirs="$1"
    local stripFlags="$2"
    local dirsNew=

    for d in ${dirs}; do
        if test -d "$prefix/$d"; then
            dirsNew="${dirsNew} $prefix/$d "
        fi
    done
    dirs=${dirsNew}

    if test -n "${dirs}"; then
        echo $dirs
        find $dirs -type f -print0 | xargs -0 strip $stripFlags || true
    fi
}


######################################################################
# Textual substitution functions.


substitute() {
    local input="$1"
    local output="$2"

    local -a params=("$@")
    local -a args=()

    local sedScript=$NIX_BUILD_TOP/.sedargs
    rm -f $sedScript
    touch $sedScript

    local n p pattern replacement varName

    for ((n = 2; n < ${#params[*]}; n += 1)); do
        p=${params[$n]}

        if test "$p" = "--replace"; then
            pattern="${params[$((n + 1))]}"
            replacement="${params[$((n + 2))]}"
            n=$((n + 2))
        fi

        if test "$p" = "--subst-var"; then
            varName="${params[$((n + 1))]}"
            pattern="@$varName@"
            replacement="${!varName}"
            n=$((n + 1))
        fi

        if test "$p" = "--subst-var-by"; then
            pattern="@${params[$((n + 1))]}@"
            replacement="${params[$((n + 2))]}"
            n=$((n + 2))
        fi

        if test ${#args[@]} != 0; then
            args[${#args[@]}]="-a"
        fi
        args[${#args[@]}]="$pattern"
        args[${#args[@]}]="$replacement"
    done

    replace-literal -e -s "${args[@]}" < "$input" > "$output".tmp
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
    local file="$1"
    local cmd

    header "unpacking source archive $file" 3

    case "$file" in
        *.tar)
            tar xvf $file || fail
            ;;
        *.tar.gz | *.tgz | *.tar.Z)
            gzip -d < $file | tar xvf - || fail
            ;;
        *.tar.bz2 | *.tbz2)
            bzip2 -d < $file | tar xvf - || fail
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
                eval "$unpackCmd" || fail
            fi
            ;;
    esac

    stopNest
}


unpackPhase() {
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


patchPhase() {
    if test -n "$patchPhase"; then
        eval "$patchPhase"
        return
    fi

    if test -z "$patchPhase" -a -z "$patches"; then return; fi
    
    if test -z "$patchFlags"; then
        patchFlags="-p1"
    fi

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
        esac
        $uncompress < $i | patch $patchFlags || fail
        stopNest
    done
}


fixLibtool() {
    sed 's^eval sys_lib_.*search_path=.*^^' < $1 > $1.tmp
    mv $1.tmp $1
}


configurePhase() {
    if test -n "$configurePhase"; then
        eval "$configurePhase"
        return
    fi

    eval "$preConfigure"

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
        configureFlags="${prefixKey:---prefix=}$prefix $configureFlags"
    fi

    # Add --disable-dependency-tracking to speed up some builds.
    if test -z "$dontAddDisableDepTrack"; then
        if grep -q dependency-tracking $configureScript; then
            configureFlags="--disable-dependency-tracking ${prefixKey:---prefix=}$prefix $configureFlags"
        fi
    fi

    echo "configure flags: $configureFlags ${configureFlagsArray[@]}"
    $configureScript $configureFlags"${configureFlagsArray[@]}" || fail

    eval "$postConfigure"
}


buildPhase() {
    if test -n "$buildPhase"; then
        eval "$buildPhase"
        return
    fi

    eval "$preBuild"

    if test -z "$makeFlags" ! test -n "$makefile" -o -e "Makefile" -o -e "makefile" -o -e "GNUmakefile"; then
        echo "no Makefile, doing nothing"
        return
    fi

    echo "make flags: $makeFlags ${makeFlagsArray[@]} $buildFlags ${buildFlagsArray[@]}"
    make ${makefile:+-f $makefile} \
        $makeFlags "${makeFlagsArray[@]}" \
        $buildFlags "${buildFlagsArray[@]}" || fail

    eval "$postBuild"
}


checkPhase() {
    if test -n "$checkPhase"; then
        eval "$checkPhase"
        return
    fi

    if test -z "$checkTarget"; then
        checkTarget="check"
    fi

    echo "check flags: $makeFlags ${makeFlagsArray[@]} $checkFlags ${checkFlagsArray[@]}"
    make ${makefile:+-f $makefile} \
        $makeFlags "${makeFlagsArray[@]}" \
        $checkFlags "${checkFlagsArray[@]}" $checkTarget || fail
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


installPhase() {
    if test -n "$installPhase"; then
        eval "$installPhase"
        return
    fi

    eval "$preInstall"

    ensureDir "$prefix"

    if test -z "$installCommand"; then
        if test -z "$installTargets"; then
            installTargets=install
        fi
        echo "install flags: $installTargets $makeFlags ${makeFlagsArray[@]} $installFlags ${installFlagsArray[@]}"
        make ${makefile:+-f $makefile} $installTargets \
            $makeFlags "${makeFlagsArray[@]}" \
            $installFlags "${installFlagsArray[@]}" || fail
    else
        eval "$installCommand"
    fi

    eval "$postInstall"
}


# The fixup phase performs generic, package-independent, Nix-related
# stuff, like running patchelf and setting the
# propagated-build-inputs.  It should rarely be overriden.
fixupPhase() {
    if test -n "$fixupPhase"; then
        eval "$fixupPhase"
        return
    fi

    eval "$preFixup"

    # Put man/doc/info under $out/share.
    forceShare=${forceShare:=man doc info}
    if test -n "$forceShare"; then
        for d in $forceShare; do
            if test -d "$prefix/$d"; then
                if test -d "$prefix/share/$d"; then
                    echo "both $d/ and share/$d/ exists!"
                else
                    echo "fixing location of $d/ subdirectory"
                    ensureDir $prefix/share
                    if test -w $prefix/share; then
                        mv -v $prefix/$d $prefix/share
                        ln -sv share/$d $prefix
                    fi
                fi
            fi
        done;
    fi

    # TODO: strip _only_ ELF executables, and return || fail here...
    if test -z "$dontStrip"; then
        stripDebugList=${stripDebugList:-lib}
        echo "stripping debuging symbols from files in $stripDebugList"
        stripDirs "$stripDebugList" -S
        stripAllList=${stripAllList:-bin sbin}
        echo "stripping all symbols from files in $stripAllList"
        stripDirs "$stripAllList" -s
    fi

    if test "$havePatchELF" = 1 -a -z "$dontPatchELF"; then
        patchELF "$prefix"
    fi

    if test -n "$propagatedBuildInputs"; then
        ensureDir "$out/nix-support"
        echo "$propagatedBuildInputs" > "$out/nix-support/propagated-build-inputs"
    fi

    if test -n "$setupHook"; then
        ensureDir "$out/nix-support"
        substituteAll "$setupHook" "$out/nix-support/setup-hook"
    fi

    eval "$postFixup"
}


distPhase() {
    if test -n "$distPhase"; then
        eval "$distPhase"
        return
    fi

    eval "$preDist"

    if test -z "$distTarget"; then
        distTarget="dist"
    fi

    echo "dist flags: $distFlags ${distFlagsArray[@]}"
    make ${makefile:+-f $makefile} $distFlags "${distFlagsArray[@]}" $distTarget || fail

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


showPhaseHeader() {
    local phase="$1"
    case $phase in
        unpackPhase) header "unpacking sources";;
        patchPhase) header "patching sources";;
        configurePhase) header "configuring";;
        buildPhase) header "building";;
        checkPhase) header "running tests";;
        installPhase) header "installing";;
        fixupPhase) header "post-installation fixup";;
        *) header "$phase";;
    esac
}


genericBuild() {
    header "building $out"

    if test -n "$buildCommand"; then
        eval "$buildCommand"
        return
    fi

    if test -z "$phases"; then
        phases="unpackPhase patchPhase configurePhase buildPhase checkPhase \
            installPhase fixupPhase distPhase $extraPhases";
    fi

    for curPhase in $phases; do
        if test "$curPhase" = buildPhase -a -n "$dontBuild"; then continue; fi
        if test "$curPhase" = checkPhase -a -z "$doCheck"; then continue; fi
        if test "$curPhase" = installPhase -a -n "$dontInstall"; then continue; fi
        if test "$curPhase" = fixupPhase -a -n "$dontFixup"; then continue; fi
        if test "$curPhase" = distPhase -a -z "$doDist"; then continue; fi
        
        showPhaseHeader "$curPhase"
        startLog "$curPhase"
        dumpVars
        
        # Evaluate the variable named $curPhase if it exists, otherwise the
        # function named $curPhase.
        eval "${!curPhase:-$curPhase}"

        if test "$curPhase" = unpackPhase; then
            cd "${sourceRoot:-.}"
        fi
        
        stopLog
        stopNest
    done

    stopNest
}


# Execute the post-hook.
if test -n "@postHook@"; then source @postHook@; fi
eval "$postHook"


dumpVars
