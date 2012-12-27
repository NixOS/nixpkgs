# Run the named hook, either by calling the function with that name or
# by evaluating the variable with that name.  This allows convenient
# setting of hooks both from Nix expressions (as attributes /
# environment variables) and from shell scripts (as functions). 
runHook() {
    local hookName="$1"
    case "$(type -t $hookName)" in
        (function|alias|builtin) $hookName;;
        (file) source $hookName;;
        (keyword) :;;
        (*) eval "${!hookName}";;
    esac
}


exitHandler() {
    exitCode=$?
    set +e

    closeNest

    if [ -n "$showBuildStats" ]; then
        times > "$NIX_BUILD_TOP/.times"
        local -a times=($(cat "$NIX_BUILD_TOP/.times"))
        # Print the following statistics:
        # - user time for the shell
        # - system time for the shell
        # - user time for all child processes
        # - system time for all child processes
        echo "build time elapsed: " ${times[*]}
    fi
    
    if [ $exitCode != 0 ]; then
        runHook failureHook
    
        # If the builder had a non-zero exit code and
        # $succeedOnFailure is set, create the file
        # `$out/nix-support/failed' to signal failure, and exit
        # normally.  Otherwise, return the original exit code.
        if [ -n "$succeedOnFailure" ]; then
            echo "build failed with exit code $exitCode (ignored)"
            mkdir -p "$out/nix-support"
            echo -n $exitCode > "$out/nix-support/failed"
            exit 0
        fi
        
    else
        runHook exitHook
    fi
    
    exit $exitCode
}

trap "exitHandler" EXIT


######################################################################
# Helper functions that might be useful in setup hooks.


addToSearchPathWithCustomDelimiter() {
    local delimiter=$1
    local varName=$2
    local dir=$3
    if [ -d "$dir" ]; then
        eval export ${varName}=${!varName}${!varName:+$delimiter}${dir}
    fi
}

PATH_DELIMITER=':'

addToSearchPath() {
    addToSearchPathWithCustomDelimiter "${PATH_DELIMITER}" "$@"
}


######################################################################
# Initialisation.

set -e

[ -z $NIX_GCC ] && NIX_GCC=@gcc@


# Wildcard expansions that don't match should expand to an empty list.
# This ensures that, for instance, "for i in *; do ...; done" does the
# right thing.
shopt -s nullglob


# Set up the initial path.
PATH=
for i in $NIX_GCC @initialPath@; do
    if [ "$i" = / ]; then i=; fi
    addToSearchPath PATH $i/bin
done

if [ "$NIX_DEBUG" = 1 ]; then
    echo "initial path: $PATH"
fi


# Execute the pre-hook.
export SHELL=@shell@
if [ -z "$shell" ]; then export shell=@shell@; fi
runHook preHook


# Check that the pre-hook initialised SHELL.
if [ -z "$SHELL" ]; then echo "SHELL not set"; exit 1; fi


# Hack: run gcc's setup hook.
envHooks=()
crossEnvHooks=()
if [ -f $NIX_GCC/nix-support/setup-hook ]; then
    source $NIX_GCC/nix-support/setup-hook
fi


# Ensure that the given directories exists.
ensureDir() {
    local dir
    for dir in "$@"; do
        if ! [ -x "$dir" ]; then mkdir -p "$dir"; fi
    done
}

installBin() {
    mkdir -p $out/bin
    cp "$@" $out/bin
}


# Allow the caller to augment buildInputs (it's not always possible to
# do this before the call to setup.sh, since the PATH is empty at that
# point; here we have a basic Unix environment).
runHook addInputsHook


# Recursively find all build inputs.
findInputs() {
    local pkg=$1
    local var=$2
    local propagatedBuildInputsFile=$3

    case ${!var} in
        *\ $pkg\ *)
            return 0
            ;;
    esac

    eval $var="'${!var} $pkg '"

    if [ -f $pkg/nix-support/setup-hook ]; then
        source $pkg/nix-support/setup-hook
    fi

    if [ -f $pkg/nix-support/$propagatedBuildInputsFile ]; then
        for i in $(cat $pkg/nix-support/$propagatedBuildInputsFile); do
            findInputs $i $var $propagatedBuildInputsFile
        done
    fi
}

crossPkgs=""
for i in $buildInputs $propagatedBuildInputs; do
    findInputs $i crossPkgs propagated-build-inputs
done

nativePkgs=""
for i in $buildNativeInputs $propagatedBuildNativeInputs; do
    findInputs $i nativePkgs propagated-build-native-inputs
done


# Set the relevant environment variables to point to the build inputs
# found above.
addToNativeEnv() {
    local pkg=$1

    if [ -d $1/bin ]; then
        addToSearchPath _PATH $1/bin
    fi

    # Run the package-specific hooks set by the setup-hook scripts.
    for i in "${envHooks[@]}"; do
        $i $pkg
    done
}

for i in $nativePkgs; do
    addToNativeEnv $i
done

addToCrossEnv() {
    local pkg=$1

    # Some programs put important build scripts (freetype-config and similar)
    # into their hostDrv bin path. Intentionally these should go after
    # the nativePkgs in PATH.
    if [ -d $1/bin ]; then
        addToSearchPath _PATH $1/bin
    fi

    # Run the package-specific hooks set by the setup-hook scripts.
    for i in "${crossEnvHooks[@]}"; do
        $i $pkg
    done
}

for i in $crossPkgs; do
    addToCrossEnv $i
done


# Add the output as an rpath.
if [ "$NIX_NO_SELF_RPATH" != 1 ]; then
    export NIX_LDFLAGS="-rpath $out/lib $NIX_LDFLAGS"
    if [ -n "$NIX_LIB64_IN_SELF_RPATH" ]; then
        export NIX_LDFLAGS="-rpath $out/lib64 $NIX_LDFLAGS"
    fi
    if [ -n "$NIX_LIB32_IN_SELF_RPATH" ]; then
        export NIX_LDFLAGS="-rpath $out/lib32 $NIX_LDFLAGS"
    fi
fi


# Set the TZ (timezone) environment variable, otherwise commands like
# `date' will complain (e.g., `Tue Mar 9 10:01:47 Local time zone must
# be set--see zic manual page 2004').
export TZ=UTC


# Set the prefix.  This is generally $out, but it can be overriden,
# for instance if we just want to perform a test build/install to a
# temporary location and write a build report to $out.
if [ -z "$prefix" ]; then
    prefix="$out";
fi

if [ "$useTempPrefix" = 1 ]; then
    prefix="$NIX_BUILD_TOP/tmp_prefix";
fi


PATH=$_PATH${_PATH:+:}$PATH
if [ "$NIX_DEBUG" = 1 ]; then
    echo "final path: $PATH"
fi


# Make GNU Make produce nested output.
export NIX_INDENT_MAKE=1


# Normalize the NIX_BUILD_CORES variable. The value might be 0, which
# means that we're supposed to try and auto-detect the number of
# available CPU cores at run-time.

if [ -z "${NIX_BUILD_CORES:-}" ]; then
  NIX_BUILD_CORES="1"
elif [ "$NIX_BUILD_CORES" -le 0 ]; then
  NIX_BUILD_CORES=$(nproc 2>/dev/null || true)
  if expr >/dev/null 2>&1 "$NIX_BUILD_CORES" : "^[0-9][0-9]*$"; then
    :
  else
    NIX_BUILD_CORES="1"
  fi
fi
export NIX_BUILD_CORES

@niximpure@

######################################################################
# Misc. helper functions.


stripDirs() {
    local dirs="$1"
    local stripFlags="$2"
    local dirsNew=

    for d in ${dirs}; do
        if [ -d "$prefix/$d" ]; then
            dirsNew="${dirsNew} $prefix/$d "
        fi
    done
    dirs=${dirsNew}

    if [ -n "${dirs}" ]; then
        header "stripping (with flags $stripFlags) in $dirs"
        find $dirs -type f -print0 | xargs -0 ${xargsFlags:--r} strip $stripFlags || true
        stopNest
    fi
}


######################################################################
# Textual substitution functions.


substitute() {
    local input="$1"
    local output="$2"

    local -a params=("$@")

    local n p pattern replacement varName

    local content="$(cat $input)"

    for ((n = 2; n < ${#params[*]}; n += 1)); do
        p=${params[$n]}

        if [ "$p" = --replace ]; then
            pattern="${params[$((n + 1))]}"
            replacement="${params[$((n + 2))]}"
            n=$((n + 2))
        fi

        if [ "$p" = --subst-var ]; then
            varName="${params[$((n + 1))]}"
            pattern="@$varName@"
            replacement="${!varName}"
            n=$((n + 1))
        fi

        if [ "$p" = --subst-var-by ]; then
            pattern="@${params[$((n + 1))]}@"
            replacement="${params[$((n + 2))]}"
            n=$((n + 2))
        fi

        content="${content//"$pattern"/$replacement}"
    done

    # !!! This doesn't work properly if $content is "-n".
    echo -n "$content" > "$output".tmp
    if [ -x "$output" ]; then chmod +x "$output".tmp; fi
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
        if [ "$NIX_DEBUG" = "1" ]; then
            echo "$envVar -> ${!envVar}"
        fi
        args="$args --subst-var $envVar"
    done

    substitute "$input" "$output" $args
}


substituteAllInPlace() {
    local fileName="$1"
    shift
    substituteAll "$fileName" "$fileName" "$@"
}


######################################################################
# What follows is the generic builder.


nestingLevel=0

startNest() {
    nestingLevel=$(($nestingLevel + 1))
    echo -en "\033[$1p"
}

stopNest() {
    nestingLevel=$(($nestingLevel - 1))
    echo -en "\033[q"
}

header() {
    startNest "$2"
    echo "$1"
}

# Make sure that even when we exit abnormally, the original nesting
# level is properly restored.
closeNest() {
    while [ $nestingLevel -gt 0 ]; do
        stopNest
    done
}


# This function is useful for debugging broken Nix builds.  It dumps
# all environment variables to a file `env-vars' in the build
# directory.  If the build fails and the `-K' option is used, you can
# then go to the build directory and source in `env-vars' to reproduce
# the environment used for building.
dumpVars() {
    if [ "$noDumpEnvVars" != 1 ]; then
        export > "$NIX_BUILD_TOP/env-vars"
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
    curSrc="$1"
    local cmd

    header "unpacking source archive $curSrc" 3

    case "$curSrc" in
        *.tar.xz | *.tar.lzma)
            # Don't rely on tar knowing about .xz.
            xz -d < $curSrc | tar xf -
            ;;
        *.tar | *.tar.* | *.tgz | *.tbz2)
            # GNU tar can automatically select the decompression method
            # (info "(tar) gzip").
            tar xf $curSrc
            ;;
        *.zip)
            unzip -qq $curSrc
            ;;
        *)
            if [ -d "$curSrc" ]; then
                stripHash $curSrc
                cp -prd --no-preserve=timestamps $curSrc $strippedName
            else
                if [ -z "$unpackCmd" ]; then
                    echo "source archive $curSrc has unknown type"
                    exit 1
                fi
                runHook unpackCmd
            fi
            ;;
    esac

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
        runHook setSourceRoot
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
    
    if [ -z "$patchPhase" -a -z "$patches" ]; then return; fi
    
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
            *.lzma)
                uncompress="lzma -d"
                ;;
        esac
        $uncompress < $i | patch ${patchFlags:--p1}
        stopNest
    done

    runHook postPatch
}


fixLibtool() {
    sed -i -e 's^eval sys_lib_.*search_path=.*^^' "$1"
}


configurePhase() {
    runHook preConfigure

    if [ -z "$configureScript" ]; then
        configureScript=./configure
        if ! [ -x $configureScript ]; then
            echo "no configure script, doing nothing"
            return
        fi
    fi

    if [ -z "$dontFixLibtool" ]; then
        for i in $(find . -name "ltmain.sh"); do
            echo "fixing libtool script $i"
            fixLibtool $i
        done
    fi

    if [ -z "$dontAddPrefix" ]; then
        configureFlags="${prefixKey:---prefix=}$prefix $configureFlags"
    fi

    # Add --disable-dependency-tracking to speed up some builds.
    if [ -z "$dontAddDisableDepTrack" ]; then
        if grep -q dependency-tracking $configureScript; then
            configureFlags="--disable-dependency-tracking $configureFlags"
        fi
    fi

    # By default, disable static builds.
    if [ -z "$dontDisableStatic" ]; then
        if grep -q enable-static $configureScript; then
            configureFlags="--disable-static $configureFlags"
        fi
    fi

    echo "configure flags: $configureFlags ${configureFlagsArray[@]}"
    $configureScript $configureFlags "${configureFlagsArray[@]}"

    runHook postConfigure
}


buildPhase() {
    runHook preBuild

    if [ -z "$makeFlags" ] && ! [ -n "$makefile" -o -e "Makefile" -o -e "makefile" -o -e "GNUmakefile" ]; then
        echo "no Makefile, doing nothing"
        return
    fi

    echo "make flags: $makeFlags ${makeFlagsArray[@]} $buildFlags ${buildFlagsArray[@]}"
    make ${makefile:+-f $makefile} \
        ${enableParallelBuilding:+-j${NIX_BUILD_CORES} -l${NIX_BUILD_CORES}} \
        $makeFlags "${makeFlagsArray[@]}" \
        $buildFlags "${buildFlagsArray[@]}"

    runHook postBuild
}


checkPhase() {
    runHook preCheck

    echo "check flags: $makeFlags ${makeFlagsArray[@]} $checkFlags ${checkFlagsArray[@]}"
    make ${makefile:+-f $makefile} \
        ${enableParallelBuilding:+-j${NIX_BUILD_CORES} -l${NIX_BUILD_CORES}} \
        $makeFlags "${makeFlagsArray[@]}" \
        ${checkFlags:-VERBOSE=y} "${checkFlagsArray[@]}" ${checkTarget:-check}

    runHook postCheck
}


patchELF() {
    # Patch all ELF executables and shared libraries.
    header "patching ELF executables and libraries"
    if [ -e "$prefix" ]; then
        find "$prefix" \( \
            \( -type f -a -name "*.so*" \) -o \
            \( -type f -a -perm +0100 \) \
            \) -print -exec patchelf --shrink-rpath {} \;
    fi
    stopNest
}


patchShebangs() {
    # Rewrite all script interpreter file names (`#! /path') under the
    # specified  directory tree to paths found in $PATH.  E.g.,
    # /bin/sh will be rewritten to /nix/store/<hash>-some-bash/bin/sh.
    # Interpreters that are already in the store are left untouched.
    header "patching script interpreter paths"
    local dir="$1"
    local f
    for f in $(find "$dir" -type f -perm +0100); do
        local oldPath=$(sed -ne '1 s,^#![ ]*\([^ ]*\).*$,\1,p' "$f")
        if [ -n "$oldPath" -a "${oldPath:0:${#NIX_STORE}}" != "$NIX_STORE" ]; then
            local newPath=$(type -P $(basename $oldPath) || true)
            if [ -n "$newPath" -a "$newPath" != "$oldPath" ]; then
                echo "$f: interpreter changed from $oldPath to $newPath"
                sed -i -e "1 s,$oldPath,$newPath," "$f"
            fi
        fi
    done
    stopNest
}


installPhase() {
    runHook preInstall

    mkdir -p "$prefix"

    installTargets=${installTargets:-install}
    echo "install flags: $installTargets $makeFlags ${makeFlagsArray[@]} $installFlags ${installFlagsArray[@]}"
    make ${makefile:+-f $makefile} $installTargets \
        $makeFlags "${makeFlagsArray[@]}" \
        $installFlags "${installFlagsArray[@]}"

    runHook postInstall
}


# The fixup phase performs generic, package-independent, Nix-related
# stuff, like running patchelf and setting the
# propagated-build-inputs.  It should rarely be overriden.
fixupPhase() {
    runHook preFixup

    # Put man/doc/info under $out/share.
    forceShare=${forceShare:=man doc info}
    if [ -n "$forceShare" ]; then
        for d in $forceShare; do
            if [ -d "$prefix/$d" ]; then
                if [ -d "$prefix/share/$d" ]; then
                    echo "both $d/ and share/$d/ exists!"
                else
                    echo "fixing location of $d/ subdirectory"
                    mkdir -p $prefix/share
                    if [ -w $prefix/share ]; then
                        mv -v $prefix/$d $prefix/share
                        ln -sv share/$d $prefix
                    fi
                fi
            fi
        done;
    fi

    if [ -z "$dontGzipMan" ]; then
        GLOBIGNORE=.:..:*.gz:*.bz2
        for f in $out/share/man/*/* $out/share/man/*/*/*; do
            if [ -f $f ]; then
                if gzip -c $f > $f.gz; then
                    rm $f
                else
                    rm $f.gz
                fi
            fi
        done
        unset GLOBIGNORE
    fi

    # TODO: strip _only_ ELF executables, and return || fail here...
    if [ -z "$dontStrip" ]; then
        stripDebugList=${stripDebugList:-lib lib64 libexec bin sbin}
        if [ -n "$stripDebugList" ]; then
            stripDirs "$stripDebugList" "${stripDebugFlags:--S}"
        fi
        
        stripAllList=${stripAllList:-}
        if [ -n "$stripAllList" ]; then
            stripDirs "$stripAllList" "${stripAllFlags:--s}"
        fi
    fi

    if [ "$havePatchELF" = 1 -a -z "$dontPatchELF" ]; then
        patchELF "$prefix"
    fi

    if [ -z "$dontPatchShebangs" ]; then
        patchShebangs "$prefix"
    fi

    if [ -n "$propagatedBuildInputs" ]; then
        mkdir -p "$out/nix-support"
        echo "$propagatedBuildInputs" > "$out/nix-support/propagated-build-inputs"
    fi

    if [ -n "$propagatedBuildNativeInputs" ]; then
        mkdir -p "$out/nix-support"
        echo "$propagatedBuildNativeInputs" > "$out/nix-support/propagated-build-native-inputs"
    fi

    if [ -n "$propagatedUserEnvPkgs" ]; then
        mkdir -p "$out/nix-support"
        echo "$propagatedUserEnvPkgs" > "$out/nix-support/propagated-user-env-packages"
    fi

    if [ -n "$setupHook" ]; then
        mkdir -p "$out/nix-support"
        substituteAll "$setupHook" "$out/nix-support/setup-hook"
    fi

    runHook postFixup
}


installCheckPhase() {
    runHook preInstallCheck

    echo "installcheck flags: $makeFlags ${makeFlagsArray[@]} $installCheckFlags ${installCheckFlagsArray[@]}"
    make ${makefile:+-f $makefile} \
        ${enableParallelBuilding:+-j${NIX_BUILD_CORES} -l${NIX_BUILD_CORES}} \
        $makeFlags "${makeFlagsArray[@]}" \
        $installCheckFlags "${installCheckFlagsArray[@]}" ${installCheckTarget:-installcheck}

    runHook postInstallCheck
}


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
        installCheckPhase) header "running install tests";;
        *) header "$phase";;
    esac
}


genericBuild() {
    header "building $out"

    if [ -n "$buildCommand" ]; then
        eval "$buildCommand"
        return
    fi

    if [ -z "$phases" ]; then
        phases="$prePhases unpackPhase patchPhase $preConfigurePhases \
            configurePhase $preBuildPhases buildPhase checkPhase \
            $preInstallPhases installPhase fixupPhase installCheckPhase \
            $preDistPhases distPhase $postPhases";
    fi

    for curPhase in $phases; do
        if [ "$curPhase" = buildPhase -a -n "$dontBuild" ]; then continue; fi
        if [ "$curPhase" = checkPhase -a -z "$doCheck" ]; then continue; fi
        if [ "$curPhase" = installPhase -a -n "$dontInstall" ]; then continue; fi
        if [ "$curPhase" = fixupPhase -a -n "$dontFixup" ]; then continue; fi
        if [ "$curPhase" = installCheckPhase -a -z "$doInstallCheck" ]; then continue; fi
        if [ "$curPhase" = distPhase -a -z "$doDist" ]; then continue; fi

        if [ -n "$tracePhases" ]; then
            echo
            echo "@ phase-started $out $curPhase"
        fi

        showPhaseHeader "$curPhase"
        dumpVars
        
        # Evaluate the variable named $curPhase if it exists, otherwise the
        # function named $curPhase.
        eval "${!curPhase:-$curPhase}"

        if [ "$curPhase" = unpackPhase ]; then
            cd "${sourceRoot:-.}"
        fi
        
        if [ -n "$tracePhases" ]; then
            echo
            echo "@ phase-succeeded $out $curPhase"
        fi

        stopNest
    done

    stopNest
}


# Execute the post-hook.
runHook postHook


dumpVars
