# Run the named hook, either by calling the function with that name or
# by evaluating the variable with that name.  This allows convenient
# setting of hooks both from Nix expressions (as attributes /
# environment variables) and from shell scripts (as functions). 
runHook() {
    local hookName="$1"
    if test "$(type -t $hookName)" = function; then
        $hookName
    else
        eval "${!hookName}"
    fi
}


exitHandler() {
    exitCode=$?
    set +e

    closeNest

    if test -n "$showBuildStats"; then
        times > "$NIX_BUILD_TOP/.times"
        local -a times=($(cat "$NIX_BUILD_TOP/.times"))
        # Print the following statistics:
        # - user time for the shell
        # - system time for the shell
        # - user time for all child processes
        # - system time for all child processes
        echo "build time elapsed: " ${times[*]}
    fi
    
    if test $exitCode != 0; then
        runHook failureHook
    
        # If the builder had a non-zero exit code and
        # $succeedOnFailure is set, create the file
        # `$out/nix-support/failed' to signal failure, and exit
        # normally.  Otherwise, return the original exit code.
        if test -n "$succeedOnFailure"; then
            echo "build failed with exit code $exitCode (ignored)"
            ensureDir "$out/nix-support"
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

# Check that the directory pointed by HOME, usually '/homeless-shelter',
# does not exist, as it may be a good source for impurities.
! test -e $HOME

test -z $NIX_GCC && NIX_GCC=@gcc@


# Wildcard expansions that don't match should expand to an empty list.
# This ensures that, for instance, "for i in *; do ...; done" does the
# right thing.
shopt -s nullglob


# Set up the initial path.
PATH=
for i in $NIX_GCC @initialPath@; do
    if test "$i" = /; then i=; fi
    addToSearchPath PATH $i/bin
done

if test "$NIX_DEBUG" = "1"; then
    echo "initial path: $PATH"
fi


# Execute the pre-hook.
export SHELL=@shell@
if test -z "$shell"; then
    export shell=@shell@
fi
param1=@param1@
param2=@param2@
param3=@param3@
param4=@param4@
param5=@param5@
if test -n "@preHook@"; then source @preHook@; fi
runHook preHook


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


# Allow the caller to augment buildInputs (it's not always possible to
# do this before the call to setup.sh, since the PATH is empty at that
# point; here we have a basic Unix environment).
runHook addInputsHook


# Recursively find all build inputs.
findInputs() {
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
for i in $buildInputs $propagatedBuildInputs; do
    findInputs $i
done


# Set the relevant environment variables to point to the build inputs
# found above.
addToEnv() {
    local pkg=$1

    if test -d $1/bin; then
        addToSearchPath _PATH $1/bin
    fi

    # Run the package-specific hooks set by the setup-hook scripts.
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
    if test -n "$NIX_LIB64_IN_SELF_RPATH"; then
        export NIX_LDFLAGS="-rpath $out/lib64 $NIX_LDFLAGS"
    fi
fi


# Strip debug information by default.
if test -z "$NIX_STRIP_DEBUG"; then
    export NIX_STRIP_DEBUG=1
    export NIX_CFLAGS_STRIP="-g0 -Wl,--strip-debug"
fi


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


# Make GNU Make produce nested output.
export NIX_INDENT_MAKE=1


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
    local -a args=()

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

    replace-literal -e -s -- "${args[@]}" < "$input" > "$output".tmp
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


# This function is useful for debugging broken Nix builds.  It dumps
# all environment variables to a file `env-vars' in the build
# directory.  If the build fails and the `-K' option is used, you can
# then go to the build directory and source in `env-vars' to reproduce
# the environment used for building.
dumpVars() {
    if test "$noDumpEnvVars" != "1"; then
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
        *.tar)
            tar xvf $curSrc
            ;;
        *.tar.gz | *.tgz | *.tar.Z)
            gzip -d < $curSrc | tar xvf -
            ;;
        *.tar.bz2 | *.tbz2)
            bzip2 -d < $curSrc | tar xvf -
            ;;
        *.zip)
            unzip $curSrc
            ;;
        *)
            if test -d "$curSrc"; then
                stripHash $curSrc
                cp -prvd $curSrc $strippedName
            else
                if test -z "$unpackCmd"; then
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
        runHook setSourceRoot
    elif test -z "$sourceRoot"; then
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
                        sourceRoot="$i"
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
    if test "$dontMakeSourcesWritable" != 1; then
        chmod -R u+w "$sourceRoot"
    fi

    runHook postUnpack
}


patchPhase() {
    runHook prePatch
    
    if test -z "$patchPhase" -a -z "$patches"; then return; fi
    
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
            configureFlags="--disable-dependency-tracking $configureFlags"
        fi
    fi

    # By default, disable static builds.
    if test -z "$dontDisableStatic"; then
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

    if test -z "$makeFlags" && ! test -n "$makefile" -o -e "Makefile" -o -e "makefile" -o -e "GNUmakefile"; then
        echo "no Makefile, doing nothing"
        return
    fi

    echo "make flags: $makeFlags ${makeFlagsArray[@]} $buildFlags ${buildFlagsArray[@]}"
    make ${makefile:+-f $makefile} \
        $makeFlags "${makeFlagsArray[@]}" \
        $buildFlags "${buildFlagsArray[@]}"

    runHook postBuild
}


checkPhase() {
    runHook preCheck

    echo "check flags: $makeFlags ${makeFlagsArray[@]} $checkFlags ${checkFlagsArray[@]}"
    make ${makefile:+-f $makefile} \
        $makeFlags "${makeFlagsArray[@]}" \
        $checkFlags "${checkFlagsArray[@]}" ${checkTarget:-check}

    runHook postCheck
}


patchELF() {
    # Patch all ELF executables and shared libraries.
    header "patching ELF executables and libraries"
    if test -e "$prefix"; then
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
        if test -n "$oldPath" -a "${oldPath:0:${#NIX_STORE}}" != "$NIX_STORE"; then
            local newPath=$(type -P $(basename $oldPath) || true)
            if test -n "$newPath" -a "$newPath" != "$oldPath"; then
                echo "$f: interpreter changed from $oldPath to $newPath"
                sed -i -e "1 s,$oldPath,$newPath," "$f"
            fi
        fi
    done
    stopNest
}


installPhase() {
    runHook preInstall

    ensureDir "$prefix"

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
        stripDebugList=${stripDebugList:-lib lib64 libexec bin sbin}
        if test -n "$stripDebugList"; then
            stripDirs "$stripDebugList" "${stripDebugFlags:--S}"
        fi
        
        stripAllList=${stripAllList:-}
        if test -n "$stripAllList"; then
            stripDirs "$stripAllList" "${stripAllFlags:--s}"
        fi
    fi

    if test "$havePatchELF" = 1 -a -z "$dontPatchELF"; then
        patchELF "$prefix"
    fi

    if test -z "$dontPatchShebangs"; then
        patchShebangs "$prefix"
    fi

    if test -n "$propagatedBuildInputs"; then
        ensureDir "$out/nix-support"
        echo "$propagatedBuildInputs" > "$out/nix-support/propagated-build-inputs"
    fi

    if test -n "$setupHook"; then
        ensureDir "$out/nix-support"
        substituteAll "$setupHook" "$out/nix-support/setup-hook"
    fi

    runHook postFixup
}


distPhase() {
    runHook preDist

    echo "dist flags: $distFlags ${distFlagsArray[@]}"
    make ${makefile:+-f $makefile} $distFlags "${distFlagsArray[@]}" ${distTarget:-dist}

    if test "$dontCopyDist" != 1; then
        ensureDir "$out/tarballs"

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
        phases="$prePhases unpackPhase patchPhase $preConfigurePhases \
            configurePhase $preBuildPhases buildPhase checkPhase \
            $preInstallPhases installPhase fixupPhase \
            $preDistPhases distPhase $postPhases";
    fi

    for curPhase in $phases; do
        if test "$curPhase" = buildPhase -a -n "$dontBuild"; then continue; fi
        if test "$curPhase" = checkPhase -a -z "$doCheck"; then continue; fi
        if test "$curPhase" = installPhase -a -n "$dontInstall"; then continue; fi
        if test "$curPhase" = fixupPhase -a -n "$dontFixup"; then continue; fi
        if test "$curPhase" = distPhase -a -z "$doDist"; then continue; fi
        
        showPhaseHeader "$curPhase"
        dumpVars
        
        # Evaluate the variable named $curPhase if it exists, otherwise the
        # function named $curPhase.
        eval "${!curPhase:-$curPhase}"

        if test "$curPhase" = unpackPhase; then
            cd "${sourceRoot:-.}"
        fi
        
        stopNest
    done

    stopNest
}


# Execute the post-hook.
if test -n "@postHook@"; then source @postHook@; fi
runHook postHook


dumpVars
