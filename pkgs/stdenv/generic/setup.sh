set -e
set -o pipefail

: ${outputs:=out}


######################################################################
# Hook handling.


# Run all hooks with the specified name in the order in which they
# were added, stopping if any fails (returns a non-zero exit
# code). The hooks for <hookName> are the shell function or variable
# <hookName>, and the values of the shell array ‘<hookName>Hooks’.
runHook() {
    local hookName="$1"
    shift
    local var="$hookName"
    if [[ "$hookName" =~ Hook$ ]]; then var+=s; else var+=Hooks; fi
    local -n var
    local hook
    for hook in "_callImplicitHook 0 $hookName" "${var[@]}"; do
        _eval "$hook" "$@"
    done
    return 0
}


# Run all hooks with the specified name, until one succeeds (returns a
# zero exit code). If none succeed, return a non-zero exit code.
runOneHook() {
    local hookName="$1"
    shift
    local var="$hookName"
    if [[ "$hookName" =~ Hook$ ]]; then var+=s; else var+=Hooks; fi
    local -n var
    local hook
    for hook in "_callImplicitHook 1 $hookName" "${var[@]}"; do
        if _eval "$hook" "$@"; then
            return 0
        fi
    done
    return 1
}


# Run the named hook, either by calling the function with that name or
# by evaluating the variable with that name. This allows convenient
# setting of hooks both from Nix expressions (as attributes /
# environment variables) and from shell scripts (as functions). If you
# want to allow multiple hooks, use runHook instead.
_callImplicitHook() {
    local def="$1"
    local hookName="$2"
    case "$(type -t "$hookName")" in
        (function|alias|builtin) "$hookName";;
        (file) source "$hookName";;
        (keyword) :;;
        (*) if [ -z "${!hookName}" ]; then return "$def"; else eval "${!hookName}"; fi;;
    esac
}


# A function wrapper around ‘eval’ that ensures that ‘return’ inside
# hooks exits the hook, not the caller.
_eval() {
    local code="$1"
    shift
    if [ "$(type -t "$code")" = function ]; then
        eval "$code \"\$@\""
    else
        eval "$code"
    fi
}


######################################################################
# Logging.

# Obsolete.
stopNest() { true; }
header() { echo "$1"; }
closeNest() { true; }

# Prints a command such that all word splits are unambiguous. We need
# to split the command in three parts because the middle format string
# will be, and must be, repeated for each argument. The first argument
# goes before the ':' and is just for convenience.
echoCmd() {
    printf "%s:" "$1"
    shift
    printf ' %q' "$@"
    echo
}


######################################################################
# Error handling.

exitHandler() {
    exitCode="$?"
    set +e

    if [ -n "$showBuildStats" ]; then
        times > "$NIX_BUILD_TOP/.times"
        local -a times=($(cat "$NIX_BUILD_TOP/.times"))
        # Print the following statistics:
        # - user time for the shell
        # - system time for the shell
        # - user time for all child processes
        # - system time for all child processes
        echo "build time elapsed: " "${times[@]}"
    fi

    if [ "$exitCode" != 0 ]; then
        runHook failureHook

        # If the builder had a non-zero exit code and
        # $succeedOnFailure is set, create the file
        # ‘$out/nix-support/failed’ to signal failure, and exit
        # normally.  Otherwise, return the original exit code.
        if [ -n "$succeedOnFailure" ]; then
            echo "build failed with exit code $exitCode (ignored)"
            mkdir -p "$out/nix-support"
            printf "%s" "$exitCode" > "$out/nix-support/failed"
            exit 0
        fi

    else
        runHook exitHook
    fi

    exit "$exitCode"
}

trap "exitHandler" EXIT


######################################################################
# Helper functions.


addToSearchPathWithCustomDelimiter() {
    local delimiter="$1"
    local varName="$2"
    local dir="$3"
    if [ -d "$dir" ]; then
        export "${varName}=${!varName}${!varName:+$delimiter}${dir}"
    fi
}

PATH_DELIMITER=':'

addToSearchPath() {
    addToSearchPathWithCustomDelimiter "${PATH_DELIMITER}" "$@"
}


ensureDir() {
    echo "warning: ‘ensureDir’ is deprecated; use ‘mkdir’ instead" >&2
    local dir
    for dir in "$@"; do
        if ! [ -x "$dir" ]; then mkdir -p "$dir"; fi
    done
}


# Add $1/lib* into rpaths.
# The function is used in multiple-outputs.sh hook,
# so it is defined here but tried after the hook.
_addRpathPrefix() {
    if [ "$NIX_NO_SELF_RPATH" != 1 ]; then
        export NIX_LDFLAGS="-rpath $1/lib $NIX_LDFLAGS"
        if [ -n "$NIX_LIB64_IN_SELF_RPATH" ]; then
            export NIX_LDFLAGS="-rpath $1/lib64 $NIX_LDFLAGS"
        fi
        if [ -n "$NIX_LIB32_IN_SELF_RPATH" ]; then
            export NIX_LDFLAGS="-rpath $1/lib32 $NIX_LDFLAGS"
        fi
    fi
}

# Return success if the specified file is an ELF object.
isELF() {
    local fn="$1"
    local fd
    local magic
    exec {fd}< "$fn"
    read -r -n 4 -u "$fd" magic
    exec {fd}<&-
    if [[ "$magic" =~ ELF ]]; then return 0; else return 1; fi
}

# Return success if the specified file is a script (i.e. starts with
# "#!").
isScript() {
    local fn="$1"
    local fd
    local magic
    if ! [ -x /bin/sh ]; then return 0; fi
    exec {fd}< "$fn"
    read -r -n 2 -u "$fd" magic
    exec {fd}<&-
    if [[ "$magic" =~ \#! ]]; then return 0; else return 1; fi
}

# printf unfortunately will print a trailing newline regardless
printLines() {
    [[ "$#" -gt 0 ]] || return 0
    printf '%s\n' "$@"
}

printWords() {
    [[ "$#" -gt 0 ]] || return 0
    printf '%s ' "$@"
}

######################################################################
# Initialisation.


# Set a fallback default value for SOURCE_DATE_EPOCH, used by some
# build tools to provide a deterministic substitute for the "current"
# time. Note that 1 = 1970-01-01 00:00:01. We don't use 0 because it
# confuses some applications.
export SOURCE_DATE_EPOCH
: ${SOURCE_DATE_EPOCH:=1}


# Wildcard expansions that don't match should expand to an empty list.
# This ensures that, for instance, "for i in *; do ...; done" does the
# right thing.
shopt -s nullglob


# Set up the initial path.
PATH=
for i in $initialPath; do
    if [ "$i" = / ]; then i=; fi
    addToSearchPath PATH "$i/bin"
done

if [ "$NIX_DEBUG" = 1 ]; then
    echo "initial path: $PATH"
fi


# Check that the pre-hook initialised SHELL.
if [ -z "$SHELL" ]; then echo "SHELL not set"; exit 1; fi
BASH="$SHELL"
export CONFIG_SHELL="$SHELL"


# Dummy implementation of the paxmark function. On Linux, this is
# overwritten by paxctl's setup hook.
paxmark() { true; }


# Execute the pre-hook.
if [ -z "$shell" ]; then export shell="$SHELL"; fi
runHook preHook


# Allow the caller to augment buildInputs (it's not always possible to
# do this before the call to setup.sh, since the PATH is empty at that
# point; here we have a basic Unix environment).
runHook addInputsHook


# Recursively find all build inputs.
findInputs() {
    local pkg="$1"
    local var="$2"
    local -n varDeref="$var"
    local propagatedBuildInputsFile="$3"

    # Stop if we've already added this one
    [[ -z "${varDeref["$pkg"]}" ]] || return 0
    varDeref["$pkg"]=1

    if ! [ -e "$pkg" ]; then
        echo "build input $pkg does not exist" >&2
        exit 1
    fi

    if [ -f "$pkg" ]; then
        source "$pkg"
    fi

    if [ -d "$pkg/bin" ]; then
        addToSearchPath _PATH "$pkg/bin"
    fi

    if [ -f "$pkg/nix-support/setup-hook" ]; then
        source "$pkg/nix-support/setup-hook"
    fi

    if [ -f "$pkg/nix-support/$propagatedBuildInputsFile" ]; then
        local pkgNext
        for pkgNext in $(< "$pkg/nix-support/$propagatedBuildInputsFile"); do
            findInputs "$pkgNext" "$var" "$propagatedBuildInputsFile"
        done
    fi
}

if [ -z "$crossConfig" ]; then
    # Not cross-compiling - both buildInputs (and variants like propagatedBuildInputs)
    # are handled identically to nativeBuildInputs
    declare -gA nativePkgs
    for i in $nativeBuildInputs $buildInputs \
             $defaultNativeBuildInputs $defaultBuildInputs \
             $propagatedNativeBuildInputs $propagatedBuildInputs; do
        findInputs "$i" nativePkgs propagated-native-build-inputs
    done
else
    declare -gA crossPkgs
    for i in $buildInputs $defaultBuildInputs $propagatedBuildInputs; do
        findInputs "$i" crossPkgs propagated-build-inputs
    done

    declare -gA nativePkgs
    for i in $nativeBuildInputs $defaultNativeBuildInputs $propagatedNativeBuildInputs; do
        findInputs "$i" nativePkgs propagated-native-build-inputs
    done
fi


# Set the relevant environment variables to point to the build inputs
# found above.
_addToNativeEnv() {
    local pkg="$1"

    # Run the package-specific hooks set by the setup-hook scripts.
    runHook envHook "$pkg"
}

for i in "${!nativePkgs[@]}"; do
    _addToNativeEnv "$i"
done

_addToCrossEnv() {
    local pkg="$1"

    # Run the package-specific hooks set by the setup-hook scripts.
    runHook crossEnvHook "$pkg"
}

for i in "${!crossPkgs[@]}"; do
    _addToCrossEnv "$i"
done


_addRpathPrefix "$out"


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


# Prevent OpenSSL-based applications from using certificates in
# /etc/ssl.
# Leave it in shells for convenience.
if [ -z "$SSL_CERT_FILE" ] && [ -z "$IN_NIX_SHELL" ]; then
  export SSL_CERT_FILE=/no-cert-file.crt
fi


######################################################################
# Textual substitution functions.


substitute() {
    local input="$1"
    local output="$2"
    shift 2

    if [ ! -f "$input" ]; then
      echo "${FUNCNAME[0]}(): ERROR: file '$input' does not exist" >&2
      return 1
    fi

    local content
    # read returns non-0 on EOF, so we want read to fail
    if IFS='' read -r -N 0 content < "$input"; then
        echo "${FUNCNAME[0]}(): ERROR: File \"$input\" has null bytes, won't process" >&2
        return 1
    fi

    while (( "$#" )); do
        case "$1" in
            --replace)
                pattern="$2"
                replacement="$3"
                shift 3
                ;;

            --subst-var)
                local varName="$2"
                shift 2
                # check if the used nix attribute name is a valid bash name
                if ! [[ "$varName" =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]]; then
                    echo "${FUNCNAME[0]}(): WARNING: substitution variables should be valid bash names," >&2
                    echo "  \"$varName\" isn't and therefore was skipped; it might be caused" >&2
                    echo "  by multi-line phases in variables - see #14907 for details." >&2
                    continue
                fi
                pattern="@$varName@"
                replacement="${!varName}"
                ;;

            --subst-var-by)
                pattern="@$2@"
                replacement="$3"
                shift 3
                ;;

            *)
                echo "${FUNCNAME[0]}(): ERROR: Invalid command line argument: $1" >&2
                return 1
                ;;
        esac

        content="${content//"$pattern"/$replacement}"
    done

    if [ -e "$output" ]; then chmod +w "$output"; fi
    printf "%s" "$content" > "$output"
}


substituteInPlace() {
    local fileName="$1"
    shift
    substitute "$fileName" "$fileName" "$@"
}


# Substitute all environment variables that do not start with an upper-case
# character or underscore. Note: other names that aren't bash-valid
# will cause an error during `substitute --subst-var`.
substituteAll() {
    local input="$1"
    local output="$2"
    local -a args=()

    # Select all environment variables that start with a lowercase character.
    for varName in $(env | sed -e $'s/^\([a-z][^= \t]*\)=.*/\\1/; t \n d'); do
        if [ "$NIX_DEBUG" = "1" ]; then
            echo "@${varName}@ -> '${!varName}'"
        fi
        args+=("--subst-var" "$varName")
    done

    substitute "$input" "$output" "${args[@]}"
}


substituteAllInPlace() {
    local fileName="$1"
    shift
    substituteAll "$fileName" "$fileName" "$@"
}


######################################################################
# What follows is the generic builder.


# This function is useful for debugging broken Nix builds.  It dumps
# all environment variables to a file `env-vars' in the build
# directory.  If the build fails and the `-K' option is used, you can
# then go to the build directory and source in `env-vars' to reproduce
# the environment used for building.
dumpVars() {
    if [ "$noDumpEnvVars" != 1 ]; then
        export > "$NIX_BUILD_TOP/env-vars" || true
    fi
}


# Utility function: echo the base name of the given path, with the
# prefix `HASH-' removed, if present.
stripHash() {
    local strippedName
    # On separate line for `set -e`
    strippedName="$(basename "$1")"
    if echo "$strippedName" | grep -q '^[a-z0-9]\{32\}-'; then
        echo "$strippedName" | cut -c34-
    else
        echo "$strippedName"
    fi
}


unpackCmdHooks+=(_defaultUnpack)
_defaultUnpack() {
    local fn="$1"

    if [ -d "$fn" ]; then

        # We can't preserve hardlinks because they may have been
        # introduced by store optimization, which might break things
        # in the build.
        cp -pr --reflink=auto "$fn" "$(stripHash "$fn")"

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
}


unpackPhase() {
    runHook preUnpack

    if [ -z "$srcs" ]; then
        if [ -z "$src" ]; then
            # shellcheck disable=SC2016
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
        unpackFile "$i"
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
        case "$i" in
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
        # shellcheck disable=SC2086
        $uncompress < "$i" 2>&1 | patch ${patchFlags:--p1}
    done

    runHook postPatch
}


fixLibtool() {
    sed -i -e 's^eval sys_lib_.*search_path=.*^^' "$1"
}


configurePhase() {
    runHook preConfigure

    if [[ -z "$configureScript" && -x ./configure ]]; then
        configureScript=./configure
    fi

    if [ -z "$dontFixLibtool" ]; then
        local i
        find . -iname "ltmain.sh" -print0 | while IFS='' read -r -d '' i; do
            echo "fixing libtool script $i"
            fixLibtool "$i"
        done
    fi

    if [[ -z "$dontAddPrefix" && -n "$prefix" ]]; then
        configureFlags="${prefixKey:---prefix=}$prefix $configureFlags"
    fi

    # Add --disable-dependency-tracking to speed up some builds.
    if [ -z "$dontAddDisableDepTrack" ]; then
        if [ -f "$configureScript" ] && grep -q dependency-tracking "$configureScript"; then
            configureFlags="--disable-dependency-tracking $configureFlags"
        fi
    fi

    # By default, disable static builds.
    if [ -z "$dontDisableStatic" ]; then
        if [ -f "$configureScript" ] && grep -q enable-static "$configureScript"; then
            configureFlags="--disable-static $configureFlags"
        fi
    fi

    if [ -n "$configureScript" ]; then
        # shellcheck disable=SC2086
        local flagsArray=($configureFlags "${configureFlagsArray[@]}")
        echoCmd 'configure flags' "${flagsArray[@]}"
        # shellcheck disable=SC2086
        $configureScript "${flagsArray[@]}"
        unset flagsArray
    else
        echo "no configure script, doing nothing"
    fi

    runHook postConfigure
}


buildPhase() {
    runHook preBuild

    if [[ -z "$makeFlags" && ! ( -n "$makefile" || -e Makefile || -e makefile || -e GNUmakefile[[ ) ]]; then
        echo "no Makefile, doing nothing"
    else
        # See https://github.com/NixOS/nixpkgs/pull/1354#issuecomment-31260409
        makeFlags="SHELL=$SHELL $makeFlags"

        # shellcheck disable=SC2086
        local flagsArray=( \
            ${enableParallelBuilding:+-j${NIX_BUILD_CORES} -l${NIX_BUILD_CORES}} \
            $makeFlags "${makeFlagsArray[@]}" \
            $buildFlags "${buildFlagsArray[@]}")

        echoCmd 'build flags' "${flagsArray[@]}"
        make ${makefile:+-f $makefile} "${flagsArray[@]}"
        unset flagsArray
    fi

    runHook postBuild
}


checkPhase() {
    runHook preCheck

    # shellcheck disable=SC2086
    local flagsArray=( \
        ${enableParallelBuilding:+-j${NIX_BUILD_CORES} -l${NIX_BUILD_CORES}} \
        $makeFlags "${makeFlagsArray[@]}" \
        ${checkFlags:-VERBOSE=y} "${checkFlagsArray[@]}" ${checkTarget:-check})

    echoCmd 'check flags' "${flagsArray[@]}"
    make ${makefile:+-f $makefile} "${flagsArray[@]}"
    unset flagsArray

    runHook postCheck
}


installPhase() {
    runHook preInstall

    if [ -n "$prefix" ]; then
        mkdir -p "$prefix"
    fi

    installTargets="${installTargets:-install}"

    # shellcheck disable=SC2086
    local flagsArray=( $installTargets \
        $makeFlags "${makeFlagsArray[@]}" \
        $installFlags "${installFlagsArray[@]}")

    echoCmd 'install flags' "${flagsArray[@]}"
    make ${makefile:+-f $makefile} "${flagsArray[@]}"
    unset flagsArray

    runHook postInstall
}


# The fixup phase performs generic, package-independent stuff, like
# stripping binaries, running patchelf and setting
# propagated-build-inputs.
fixupPhase() {
    # Make sure everything is writable so "strip" et al. work.
    for output in $outputs; do
        if [ -e "${!output}" ]; then chmod -R u+w "${!output}"; fi
    done

    runHook preFixup

    # Apply fixup to each output.
    local output
    for output in $outputs; do
        prefix="${!output}" runHook fixupOutput
    done


    # Propagate build inputs and setup hook into the development output.

    if [ -z "$crossConfig" ]; then
        # Not cross-compiling - propagatedBuildInputs are handled identically to propagatedNativeBuildInputs
        local propagated="$propagatedNativeBuildInputs"
        if [ -n "$propagatedBuildInputs" ]; then
            propagated+="${propagated:+ }$propagatedBuildInputs"
        fi
        if [ -n "$propagated" ]; then
            mkdir -p "${!outputDev}/nix-support"
            # shellcheck disable=SC2086
            printWords $propagated > "${!outputDev}/nix-support/propagated-native-build-inputs"
        fi
    else
        if [ -n "$propagatedBuildInputs" ]; then
            mkdir -p "${!outputDev}/nix-support"
            # shellcheck disable=SC2086
            printWords $propagatedBuildInputs > "${!outputDev}/nix-support/propagated-build-inputs"
        fi

        if [ -n "$propagatedNativeBuildInputs" ]; then
            mkdir -p "${!outputDev}/nix-support"
            # shellcheck disable=SC2086
            printWords $propagatedNativeBuildInputs > "${!outputDev}/nix-support/propagated-native-build-inputs"
        fi
    fi

    if [ -n "$setupHook" ]; then
        mkdir -p "${!outputDev}/nix-support"
        substituteAll "$setupHook" "${!outputDev}/nix-support/setup-hook"
    fi

    # Propagate user-env packages into the output with binaries, TODO?

    if [ -n "$propagatedUserEnvPkgs" ]; then
        mkdir -p "${!outputBin}/nix-support"
        # shellcheck disable=SC2086
        printWords $propagatedUserEnvPkgs > "${!outputBin}/nix-support/propagated-user-env-packages"
    fi

    runHook postFixup
}


installCheckPhase() {
    runHook preInstallCheck

    # shellcheck disable=SC2086
    local flagsArray=( \
        ${enableParallelBuilding:+-j${NIX_BUILD_CORES} -l${NIX_BUILD_CORES}} \
        $makeFlags "${makeFlagsArray[@]}" \
        $installCheckFlags "${installCheckFlagsArray[@]}" ${installCheckTarget:-installcheck})

    echoCmd 'installcheck flags' "${flagsArray[@]}"
    make ${makefile:+-f $makefile} "${flagsArray[@]}"
    unset flagsArray

    runHook postInstallCheck
}


distPhase() {
    runHook preDist

    # shellcheck disable=SC2086
    local flagsArray=($distFlags "${distFlagsArray[@]}" ${distTarget:-dist})

    echo 'dist flags: %q' "${flagsArray[@]}"
    make ${makefile:+-f $makefile} "${flagsArray[@]}"

    if [ "$dontCopyDist" != 1 ]; then
        mkdir -p "$out/tarballs"

        # Note: don't quote $tarballs, since we explicitly permit
        # wildcards in there.
        # shellcheck disable=SC2086
        cp -pvd ${tarballs:-*.tar.gz} "$out/tarballs"
    fi

    runHook postDist
}


showPhaseHeader() {
    local phase="$1"
    case "$phase" in
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
    if [ -f "$buildCommandPath" ]; then
        . "$buildCommandPath"
        return
    fi
    if [ -n "$buildCommand" ]; then
        eval "$buildCommand"
        return
    fi

    if [ -z "$phases" ]; then
        phases="$prePhases unpackPhase patchPhase $preConfigurePhases \
            configurePhase $preBuildPhases buildPhase checkPhase \
            $preInstallPhases installPhase $preFixupPhases fixupPhase installCheckPhase \
            $preDistPhases distPhase $postPhases";
    fi

    for curPhase in $phases; do
        if [[ "$curPhase" = buildPhase && -n "$dontBuild" ]]; then continue; fi
        if [[ "$curPhase" = checkPhase && -z "$doCheck" ]]; then continue; fi
        if [[ "$curPhase" = installPhase && -n "$dontInstall" ]]; then continue; fi
        if [[ "$curPhase" = fixupPhase && -n "$dontFixup" ]]; then continue; fi
        if [[ "$curPhase" = installCheckPhase && -z "$doInstallCheck" ]]; then continue; fi
        if [[ "$curPhase" = distPhase && -z "$doDist" ]]; then continue; fi

        if [[ -n "$tracePhases" ]]; then
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
    done
}


# Execute the post-hooks.
runHook postHook


# Execute the global user hook (defined through the Nixpkgs
# configuration option ‘stdenv.userHook’).  This can be used to set
# global compiler optimisation flags, for instance.
runHook userHook


dumpVars
