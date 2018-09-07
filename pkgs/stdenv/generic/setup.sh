set -eu
set -o pipefail

if (( "${NIX_DEBUG:-0}" >= 6 )); then
    set -x
fi

: ${outputs:=out}


######################################################################
# Hook handling.


# Run all hooks with the specified name in the order in which they
# were added, stopping if any fails (returns a non-zero exit
# code). The hooks for <hookName> are the shell function or variable
# <hookName>, and the values of the shell array ‘<hookName>Hooks’.
runHook() {
    local oldOpts="$(shopt -po nounset)"
    set -u # May be called from elsewhere, so do `set -u`.

    local hookName="$1"
    shift
    local hooksSlice="${hookName%Hook}Hooks[@]"

    local hook
    # Hack around old bash being bad and thinking empty arrays are
    # undefined.
    for hook in "_callImplicitHook 0 $hookName" ${!hooksSlice+"${!hooksSlice}"}; do
        _eval "$hook" "$@"
        set -u # To balance `_eval`
    done

    eval "${oldOpts}"
    return 0
}


# Run all hooks with the specified name, until one succeeds (returns a
# zero exit code). If none succeed, return a non-zero exit code.
runOneHook() {
    local oldOpts="$(shopt -po nounset)"
    set -u # May be called from elsewhere, so do `set -u`.

    local hookName="$1"
    shift
    local hooksSlice="${hookName%Hook}Hooks[@]"

    local hook ret=1
    # Hack around old bash like above
    for hook in "_callImplicitHook 1 $hookName" ${!hooksSlice+"${!hooksSlice}"}; do
        if _eval "$hook" "$@"; then
            ret=0
            break
        fi
        set -u # To balance `_eval`
    done

    eval "${oldOpts}"
    return "$ret"
}


# Run the named hook, either by calling the function with that name or
# by evaluating the variable with that name. This allows convenient
# setting of hooks both from Nix expressions (as attributes /
# environment variables) and from shell scripts (as functions). If you
# want to allow multiple hooks, use runHook instead.
_callImplicitHook() {
    set -u
    local def="$1"
    local hookName="$2"
    case "$(type -t "$hookName")" in
        (function|alias|builtin)
            set +u
            "$hookName";;
        (file)
            set +u
            source "$hookName";;
        (keyword) :;;
        (*) if [ -z "${!hookName:-}" ]; then
                return "$def";
            else
                set +u
                eval "${!hookName}"
            fi;;
    esac
    # `_eval` expects hook to need nounset disable and leave it
    # disabled anyways, so Ok to to delegate. The alternative of a
    # return trap is no good because it would affect nested returns.
}


# A function wrapper around ‘eval’ that ensures that ‘return’ inside
# hooks exits the hook, not the caller. Also will only pass args if
# command can take them
_eval() {
    if [ "$(type -t "$1")" = function ]; then
        set +u
        "$@" # including args
    else
        set +u
        eval "$1"
    fi
    # `run*Hook` reenables `set -u`
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

    if [ -n "${showBuildStats:-}" ]; then
        times > "$NIX_BUILD_TOP/.times"
        local -a times=($(cat "$NIX_BUILD_TOP/.times"))
        # Print the following statistics:
        # - user time for the shell
        # - system time for the shell
        # - user time for all child processes
        # - system time for all child processes
        echo "build time elapsed: " "${times[@]}"
    fi

    if (( "$exitCode" != 0 )); then
        runHook failureHook

        # If the builder had a non-zero exit code and
        # $succeedOnFailure is set, create the file
        # ‘$out/nix-support/failed’ to signal failure, and exit
        # normally.  Otherwise, return the original exit code.
        if [ -n "${succeedOnFailure:-}" ]; then
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
        export "${varName}=${!varName:+${!varName}${delimiter}}${dir}"
    fi
}

PATH_DELIMITER=':'

addToSearchPath() {
    addToSearchPathWithCustomDelimiter "${PATH_DELIMITER}" "$@"
}

# Add $1/lib* into rpaths.
# The function is used in multiple-outputs.sh hook,
# so it is defined here but tried after the hook.
_addRpathPrefix() {
    if [ "${NIX_NO_SELF_RPATH:-0}" != 1 ]; then
        export NIX_LDFLAGS="-rpath $1/lib $NIX_LDFLAGS"
        if [ -n "${NIX_LIB64_IN_SELF_RPATH:-}" ]; then
            export NIX_LDFLAGS="-rpath $1/lib64 $NIX_LDFLAGS"
        fi
        if [ -n "${NIX_LIB32_IN_SELF_RPATH:-}" ]; then
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
    exec {fd}< "$fn"
    read -r -n 2 -u "$fd" magic
    exec {fd}<&-
    if [[ "$magic" =~ \#! ]]; then return 0; else return 1; fi
}

# printf unfortunately will print a trailing newline regardless
printLines() {
    (( "$#" > 0 )) || return 0
    printf '%s\n' "$@"
}

printWords() {
    (( "$#" > 0 )) || return 0
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

if (( "${NIX_DEBUG:-0}" >= 1 )); then
    echo "initial path: $PATH"
fi


# Check that the pre-hook initialised SHELL.
if [ -z "${SHELL:-}" ]; then echo "SHELL not set"; exit 1; fi
BASH="$SHELL"
export CONFIG_SHELL="$SHELL"


# Dummy implementation of the paxmark function. On Linux, this is
# overwritten by paxctl's setup hook.
paxmark() { true; }


# Execute the pre-hook.
if [ -z "${shell:-}" ]; then export shell="$SHELL"; fi
runHook preHook


# Allow the caller to augment buildInputs (it's not always possible to
# do this before the call to setup.sh, since the PATH is empty at that
# point; here we have a basic Unix environment).
runHook addInputsHook


# Package accumulators

# shellcheck disable=SC2034
declare -a pkgsBuildBuild pkgsBuildHost pkgsBuildTarget
declare -a pkgsHostHost pkgsHostTarget
declare -a pkgsTargetTarget

declare -ra pkgBuildAccumVars=(pkgsBuildBuild pkgsBuildHost pkgsBuildTarget)
declare -ra pkgHostAccumVars=(pkgsHostHost pkgsHostTarget)
declare -ra pkgTargetAccumVars=(pkgsTargetTarget)

declare -ra pkgAccumVarVars=(pkgBuildAccumVars pkgHostAccumVars pkgTargetAccumVars)


# Hooks

declare -a envBuildBuildHooks envBuildHostHooks envBuildTargetHooks
declare -a envHostHostHooks envHostTargetHooks
declare -a envTargetTargetHooks

declare -ra pkgBuildHookVars=(envBuildBuildHook envBuildHostHook envBuildTargetHook)
declare -ra pkgHostHookVars=(envHostHostHook envHostTargetHook)
declare -ra pkgTargetHookVars=(envTargetTargetHook)

declare -ra pkgHookVarVars=(pkgBuildHookVars pkgHostHookVars pkgTargetHookVars)

# Add env hooks for all sorts of deps with the specified host offset.
addEnvHooks() {
    local depHostOffset="$1"
    shift
    local pkgHookVarsSlice="${pkgHookVarVars[$depHostOffset + 1]}[@]"
    local pkgHookVar
    for pkgHookVar in "${!pkgHookVarsSlice}"; do
        eval "${pkgHookVar}s"'+=("$@")'
    done
}


# Propagated dep files

declare -ra propagatedBuildDepFiles=(
    propagated-build-build-deps
    propagated-native-build-inputs # Legacy name for back-compat
    propagated-build-target-deps
)
declare -ra propagatedHostDepFiles=(
    propagated-host-host-deps
    propagated-build-inputs # Legacy name for back-compat
)
declare -ra propagatedTargetDepFiles=(
    propagated-target-target-deps
)
declare -ra propagatedDepFilesVars=(
    propagatedBuildDepFiles
    propagatedHostDepFiles
    propagatedTargetDepFiles
)

# Platform offsets: build = -1, host = 0, target = 1
declare -ra allPlatOffsets=(-1 0 1)


# Mutually-recursively find all build inputs. See the dependency section of the
# stdenv chapter of the Nixpkgs manual for the specification this algorithm
# implements.
findInputs() {
    local -r pkg="$1"
    local -ri hostOffset="$2"
    local -ri targetOffset="$3"

    # Sanity check
    (( "$hostOffset" <= "$targetOffset" )) || exit -1

    local varVar="${pkgAccumVarVars[$hostOffset + 1]}"
    local varRef="$varVar[\$targetOffset - \$hostOffset]"
    local var="${!varRef}"
    unset -v varVar varRef

    # TODO(@Ericson2314): Restore using associative array once Darwin
    # nix-shell doesn't use impure bash. This should replace the O(n)
    # case with an O(1) hash map lookup, assuming bash is implemented
    # well :D.
    local varSlice="$var[*]"
    # ${..-} to hack around old bash empty array problem
    case "${!varSlice-}" in
        *" $pkg "*) return 0 ;;
    esac
    unset -v varSlice

    eval "$var"'+=("$pkg")'

    if ! [ -e "$pkg" ]; then
        echo "build input $pkg does not exist" >&2
        exit 1
    fi

    # The current package's host and target offset together
    # provide a <=-preserving homomorphism from the relative
    # offsets to current offset
    function mapOffset() {
        local -ri inputOffset="$1"
        if (( "$inputOffset" <= 0 )); then
            local -ri outputOffset="$inputOffset + $hostOffset"
        else
            local -ri outputOffset="$inputOffset - 1 + $targetOffset"
        fi
        echo "$outputOffset"
    }

    # Host offset relative to that of the package whose immediate
    # dependencies we are currently exploring.
    local -i relHostOffset
    for relHostOffset in "${allPlatOffsets[@]}"; do
        # `+ 1` so we start at 0 for valid index
        local files="${propagatedDepFilesVars[$relHostOffset + 1]}"

        # Host offset relative to the package currently being
        # built---as absolute an offset as will be used.
        local -i hostOffsetNext
        hostOffsetNext="$(mapOffset relHostOffset)"

        # Ensure we're in bounds relative to the package currently
        # being built.
        [[ "${allPlatOffsets[*]}" = *"$hostOffsetNext"*  ]] || continue

        # Target offset relative to the *host* offset of the package
        # whose immediate dependencies we are currently exploring.
        local -i relTargetOffset
        for relTargetOffset in "${allPlatOffsets[@]}"; do
            (( "$relHostOffset" <= "$relTargetOffset" )) || continue

            local fileRef="${files}[$relTargetOffset - $relHostOffset]"
            local file="${!fileRef}"
            unset -v fileRef

            # Target offset relative to the package currently being
            # built.
            local -i targetOffsetNext
            targetOffsetNext="$(mapOffset relTargetOffset)"

            # Once again, ensure we're in bounds relative to the
            # package currently being built.
            [[ "${allPlatOffsets[*]}" = *"$targetOffsetNext"* ]] || continue

            [[ -f "$pkg/nix-support/$file" ]] || continue

            local pkgNext
            for pkgNext in $(< "$pkg/nix-support/$file"); do
                findInputs "$pkgNext" "$hostOffsetNext" "$targetOffsetNext"
            done
        done
    done
}

# Make sure all are at least defined as empty
: ${depsBuildBuild=} ${depsBuildBuildPropagated=}
: ${nativeBuildInputs=} ${propagatedNativeBuildInputs=} ${defaultNativeBuildInputs=}
: ${depsBuildTarget=} ${depsBuildTargetPropagated=}
: ${depsHostHost=} ${depsHostHostPropagated=}
: ${buildInputs=} ${propagatedBuildInputs=} ${defaultBuildInputs=}
: ${depsTargetTarget=} ${depsTargetTargetPropagated=}

for pkg in $depsBuildBuild $depsBuildBuildPropagated; do
    findInputs "$pkg" -1 -1
done
for pkg in $nativeBuildInputs $propagatedNativeBuildInputs; do
    findInputs "$pkg" -1  0
done
for pkg in $depsBuildTarget $depsBuildTargetPropagated; do
    findInputs "$pkg" -1  1
done
for pkg in $depsHostHost $depsHostHostPropagated; do
    findInputs "$pkg"  0  0
done
for pkg in $buildInputs $propagatedBuildInputs ; do
    findInputs "$pkg"  0  1
done
for pkg in $depsTargetTarget $depsTargetTargetPropagated; do
    findInputs "$pkg"  1  1
done
# Default inputs must be processed last
for pkg in $defaultNativeBuildInputs; do
    findInputs "$pkg" -1  0
done
for pkg in $defaultBuildInputs; do
    findInputs "$pkg"  0  1
done

# Add package to the future PATH and run setup hooks
activatePackage() {
    local pkg="$1"
    local -ri hostOffset="$2"
    local -ri targetOffset="$3"

    # Sanity check
    (( "$hostOffset" <= "$targetOffset" )) || exit -1

    if [ -f "$pkg" ]; then
        local oldOpts="$(shopt -po nounset)"
        set +u
        source "$pkg"
        eval "$oldOpts"
    fi

    # Only dependencies whose host platform is guaranteed to match the
    # build platform are included here. That would be `depsBuild*`,
    # and legacy `nativeBuildInputs`, in general. If we aren't cross
    # compiling, however, everything can be put on the PATH. To ease
    # the transition, we do include everything in thatcase.
    #
    # TODO(@Ericson2314): Don't special-case native compilation
    if [[ ( -z "${strictDeps-}" ||  "$hostOffset" -le -1 ) && -d "$pkg/bin" ]]; then
        addToSearchPath _PATH "$pkg/bin"
    fi

    if [[ "$hostOffset" -eq 0 && -d "$pkg/bin" ]]; then
        addToSearchPath HOST_PATH "$pkg/bin"
    fi

    if [[ -f "$pkg/nix-support/setup-hook" ]]; then
        local oldOpts="$(shopt -po nounset)"
        set +u
        source "$pkg/nix-support/setup-hook"
        eval "$oldOpts"
    fi
}

_activatePkgs() {
    local -i hostOffset targetOffset
    local pkg

    for hostOffset in "${allPlatOffsets[@]}"; do
        local pkgsVar="${pkgAccumVarVars[$hostOffset + 1]}"
        for targetOffset in "${allPlatOffsets[@]}"; do
            (( "$hostOffset" <= "$targetOffset" )) || continue
            local pkgsRef="${pkgsVar}[$targetOffset - $hostOffset]"
            local pkgsSlice="${!pkgsRef}[@]"
            for pkg in ${!pkgsSlice+"${!pkgsSlice}"}; do
                activatePackage "$pkg" "$hostOffset" "$targetOffset"
            done
        done
    done
}

# Run the package setup hooks and build _PATH
_activatePkgs

# Set the relevant environment variables to point to the build inputs
# found above.
#
# These `depOffset`s, beyond indexing the arrays, also tell the env
# hook what sort of dependency (ignoring propagatedness) is being
# passed to the env hook. In a real language, we'd append a closure
# with this information to the relevant env hook array, but bash
# doesn't have closures, so it's easier to just pass this in.
_addToEnv() {
    local -i depHostOffset depTargetOffset
    local pkg

    for depHostOffset in "${allPlatOffsets[@]}"; do
        local hookVar="${pkgHookVarVars[$depHostOffset + 1]}"
        local pkgsVar="${pkgAccumVarVars[$depHostOffset + 1]}"
        for depTargetOffset in "${allPlatOffsets[@]}"; do
            (( "$depHostOffset" <= "$depTargetOffset" )) || continue
            local hookRef="${hookVar}[$depTargetOffset - $depHostOffset]"
            if [[ -z "${strictDeps-}" ]]; then
                # Apply environment hooks to all packages during native
                # compilation to ease the transition.
                #
                # TODO(@Ericson2314): Don't special-case native compilation
                for pkg in \
                    ${pkgsBuildBuild+"${pkgsBuildBuild[@]}"} \
                    ${pkgsBuildHost+"${pkgsBuildHost[@]}"} \
                    ${pkgsBuildTarget+"${pkgsBuildTarget[@]}"} \
                    ${pkgsHostHost+"${pkgsHostHost[@]}"} \
                    ${pkgsHostTarget+"${pkgsHostTarget[@]}"} \
                    ${pkgsTargetTarget+"${pkgsTargetTarget[@]}"}
                do
                    runHook "${!hookRef}" "$pkg"
                done
            else
                local pkgsRef="${pkgsVar}[$depTargetOffset - $depHostOffset]"
                local pkgsSlice="${!pkgsRef}[@]"
                for pkg in ${!pkgsSlice+"${!pkgsSlice}"}; do
                    runHook "${!hookRef}" "$pkg"
                done
            fi
        done
    done
}

# Run the package-specific hooks set by the setup-hook scripts.
_addToEnv


_addRpathPrefix "$out"


# Set the TZ (timezone) environment variable, otherwise commands like
# `date' will complain (e.g., `Tue Mar 9 10:01:47 Local time zone must
# be set--see zic manual page 2004').
export TZ=UTC


# Set the prefix.  This is generally $out, but it can be overriden,
# for instance if we just want to perform a test build/install to a
# temporary location and write a build report to $out.
if [ -z "${prefix:-}" ]; then
    prefix="$out";
fi

if [ "${useTempPrefix:-}" = 1 ]; then
    prefix="$NIX_BUILD_TOP/tmp_prefix";
fi


PATH="${_PATH-}${_PATH:+${PATH:+:}}$PATH"
if (( "${NIX_DEBUG:-0}" >= 1 )); then
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
if [ -z "${SSL_CERT_FILE:-}" ] && [ -z "${IN_NIX_SHELL:-}" ]; then
  export SSL_CERT_FILE=/no-cert-file.crt
fi


######################################################################
# Textual substitution functions.


substituteStream() {
    local var=$1
    shift

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
                    echo "substituteStream(): ERROR: substitution variables must be valid Bash names, \"$varName\" isn't." >&2
                    return 1
                fi
                if [ -z ${!varName+x} ]; then
                    echo "substituteStream(): ERROR: variable \$$varName is unset" >&2
                    return 1
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
                echo "substituteStream(): ERROR: Invalid command line argument: $1" >&2
                return 1
                ;;
        esac

        eval "$var"'=${'"$var"'//"$pattern"/"$replacement"}'
    done

    printf "%s" "${!var}"
}

consumeEntire() {
    # read returns non-0 on EOF, so we want read to fail
    if IFS='' read -r -N 0 $1; then
        echo "consumeEntire(): ERROR: Input null bytes, won't process" >&2
        return 1
    fi
}

substitute() {
    local input="$1"
    local output="$2"
    shift 2

    if [ ! -f "$input" ]; then
        echo "substitute(): ERROR: file '$input' does not exist" >&2
        return 1
    fi

    local content
    consumeEntire content < "$input"

    if [ -e "$output" ]; then chmod +w "$output"; fi
    substituteStream content "$@" > "$output"
}

substituteInPlace() {
    local fileName="$1"
    shift
    substitute "$fileName" "$fileName" "$@"
}

_allFlags() {
    for varName in $(awk 'BEGIN { for (v in ENVIRON) if (v ~ /^[a-z][a-zA-Z0-9_]*$/) print v }'); do
        if (( "${NIX_DEBUG:-0}" >= 1 )); then
            printf "@%s@ -> %q\n" "${varName}" "${!varName}"
        fi
        args+=("--subst-var" "$varName")
    done
}

substituteAllStream() {
    local -a args=()
    _allFlags

    substituteStream "$1" "${args[@]}"
}

# Substitute all environment variables that start with a lowercase character and
# are valid Bash names.
substituteAll() {
    local input="$1"
    local output="$2"

    local -a args=()
    _allFlags

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
    if [ "${noDumpEnvVars:-0}" != 1 ]; then
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
        cp -pr --reflink=auto -- "$fn" "$(stripHash "$fn")"

    else

        case "$fn" in
            *.tar.xz | *.tar.lzma | *.txz)
                # Don't rely on tar knowing about .xz.
                xz -d < "$fn" | tar xf -
                ;;
            *.tar | *.tar.* | *.tgz | *.tbz2 | *.tbz)
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

    if [ -z "${srcs:-}" ]; then
        if [ -z "${src:-}" ]; then
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

    # set to empty if unset
    : ${sourceRoot=}

    if [ -n "${setSourceRoot:-}" ]; then
        runOneHook setSourceRoot
    elif [ -z "$sourceRoot" ]; then
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
    if [ "${dontMakeSourcesWritable:-0}" != 1 ]; then
        chmod -R u+w -- "$sourceRoot"
    fi

    runHook postUnpack
}


patchPhase() {
    runHook prePatch

    for i in ${patches:-}; do
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

    # set to empty if unset
    : ${configureScript=}
    : ${configureFlags=}

    if [[ -z "$configureScript" && -x ./configure ]]; then
        configureScript=./configure
    fi

    if [ -z "${dontFixLibtool:-}" ]; then
        local i
        find . -iname "ltmain.sh" -print0 | while IFS='' read -r -d '' i; do
            echo "fixing libtool script $i"
            fixLibtool "$i"
        done
    fi

    if [[ -z "${dontAddPrefix:-}" && -n "$prefix" ]]; then
        configureFlags="${prefixKey:---prefix=}$prefix $configureFlags"
    fi

    # Add --disable-dependency-tracking to speed up some builds.
    if [ -z "${dontAddDisableDepTrack:-}" ]; then
        if [ -f "$configureScript" ] && grep -q dependency-tracking "$configureScript"; then
            configureFlags="--disable-dependency-tracking $configureFlags"
        fi
    fi

    # By default, disable static builds.
    if [ -z "${dontDisableStatic:-}" ]; then
        if [ -f "$configureScript" ] && grep -q enable-static "$configureScript"; then
            configureFlags="--disable-static $configureFlags"
        fi
    fi

    if [ -n "$configureScript" ]; then
        # Old bash empty array hack
        # shellcheck disable=SC2086
        local flagsArray=(
            $configureFlags ${configureFlagsArray+"${configureFlagsArray[@]}"}
        )
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

    # set to empty if unset
    : ${makeFlags=}

    if [[ -z "$makeFlags" && -z "${makefile:-}" && ! ( -e Makefile || -e makefile || -e GNUmakefile ) ]]; then
        echo "no Makefile, doing nothing"
    else
        foundMakefile=1

        # See https://github.com/NixOS/nixpkgs/pull/1354#issuecomment-31260409
        makeFlags="SHELL=$SHELL $makeFlags"

        # Old bash empty array hack
        # shellcheck disable=SC2086
        local flagsArray=(
            ${enableParallelBuilding:+-j${NIX_BUILD_CORES} -l${NIX_BUILD_CORES}}
            $makeFlags ${makeFlagsArray+"${makeFlagsArray[@]}"}
            $buildFlags ${buildFlagsArray+"${buildFlagsArray[@]}"}
        )

        echoCmd 'build flags' "${flagsArray[@]}"
        make ${makefile:+-f $makefile} "${flagsArray[@]}"
        unset flagsArray
    fi

    runHook postBuild
}


checkPhase() {
    runHook preCheck

    if [[ -z "${foundMakefile:-}" ]]; then
        echo "no Makefile or custom buildPhase, doing nothing"
        runHook postCheck
        return
    fi

    if [[ -z "${checkTarget:-}" ]]; then
        #TODO(@oxij): should flagsArray influence make -n?
        if make -n ${makefile:+-f $makefile} check >/dev/null 2>&1; then
            checkTarget=check
        elif make -n ${makefile:+-f $makefile} test >/dev/null 2>&1; then
            checkTarget=test
        fi
    fi

    if [[ -z "${checkTarget:-}" ]]; then
        echo "no check/test target in ${makefile:-Makefile}, doing nothing"
    else
        # Old bash empty array hack
        # shellcheck disable=SC2086
        local flagsArray=(
            ${enableParallelBuilding:+-j${NIX_BUILD_CORES} -l${NIX_BUILD_CORES}}
            $makeFlags ${makeFlagsArray+"${makeFlagsArray[@]}"}
            ${checkFlags:-VERBOSE=y} ${checkFlagsArray+"${checkFlagsArray[@]}"}
            ${checkTarget}
        )

        echoCmd 'check flags' "${flagsArray[@]}"
        make ${makefile:+-f $makefile} "${flagsArray[@]}"

        unset flagsArray
    fi

    runHook postCheck
}


installPhase() {
    runHook preInstall

    if [ -n "$prefix" ]; then
        mkdir -p "$prefix"
    fi

    # Old bash empty array hack
    # shellcheck disable=SC2086
    local flagsArray=(
        $makeFlags ${makeFlagsArray+"${makeFlagsArray[@]}"}
        $installFlags ${installFlagsArray+"${installFlagsArray[@]}"}
        ${installTargets:-install}
    )

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
    local output
    for output in $outputs; do
        if [ -e "${!output}" ]; then chmod -R u+w "${!output}"; fi
    done

    runHook preFixup

    # Apply fixup to each output.
    local output
    for output in $outputs; do
        prefix="${!output}" runHook fixupOutput
    done


    # Propagate dependencies & setup hook into the development output.
    declare -ra flatVars=(
        # Build
        depsBuildBuildPropagated
        propagatedNativeBuildInputs
        depsBuildTargetPropagated
        # Host
        depsHostHostPropagated
        propagatedBuildInputs
        # Target
        depsTargetTargetPropagated
    )
    declare -ra flatFiles=(
        "${propagatedBuildDepFiles[@]}"
        "${propagatedHostDepFiles[@]}"
        "${propagatedTargetDepFiles[@]}"
    )

    local propagatedInputsIndex
    for propagatedInputsIndex in "${!flatVars[@]}"; do
        local propagatedInputsSlice="${flatVars[$propagatedInputsIndex]}[@]"
        local propagatedInputsFile="${flatFiles[$propagatedInputsIndex]}"

        [[ "${!propagatedInputsSlice}" ]] || continue

        mkdir -p "${!outputDev}/nix-support"
        # shellcheck disable=SC2086
        printWords ${!propagatedInputsSlice} > "${!outputDev}/nix-support/$propagatedInputsFile"
    done


    if [ -n "${setupHook:-}" ]; then
        mkdir -p "${!outputDev}/nix-support"
        substituteAll "$setupHook" "${!outputDev}/nix-support/setup-hook"
    fi

    # TODO(@Ericson2314): Remove after https://github.com/NixOS/nixpkgs/pull/31414
    if [ -n "${setupHooks:-}" ]; then
        mkdir -p "${!outputDev}/nix-support"
        local hook
        for hook in $setupHooks; do
            local content
            consumeEntire content < "$hook"
            substituteAllStream content >> "${!outputDev}/nix-support/setup-hook"
            unset -v content
        done
        unset -v hook
    fi

    # Propagate user-env packages into the output with binaries, TODO?

    if [ -n "${propagatedUserEnvPkgs:-}" ]; then
        mkdir -p "${!outputBin}/nix-support"
        # shellcheck disable=SC2086
        printWords $propagatedUserEnvPkgs > "${!outputBin}/nix-support/propagated-user-env-packages"
    fi

    runHook postFixup
}


installCheckPhase() {
    runHook preInstallCheck

    if [[ -z "${foundMakefile:-}" ]]; then
        echo "no Makefile or custom buildPhase, doing nothing"
    #TODO(@oxij): should flagsArray influence make -n?
    elif [[ -z "${installCheckTarget:-}" ]] \
       && ! make -n ${makefile:+-f $makefile} ${installCheckTarget:-installcheck} >/dev/null 2>&1; then
        echo "no installcheck target in ${makefile:-Makefile}, doing nothing"
    else
        # Old bash empty array hack
        # shellcheck disable=SC2086
        local flagsArray=(
            ${enableParallelBuilding:+-j${NIX_BUILD_CORES} -l${NIX_BUILD_CORES}}
            $makeFlags ${makeFlagsArray+"${makeFlagsArray[@]}"}
            $installCheckFlags ${installCheckFlagsArray+"${installCheckFlagsArray[@]}"}
            ${installCheckTarget:-installcheck}
        )

        echoCmd 'installcheck flags' "${flagsArray[@]}"
        make ${makefile:+-f $makefile} "${flagsArray[@]}"
        unset flagsArray
    fi

    runHook postInstallCheck
}


distPhase() {
    runHook preDist

    # Old bash empty array hack
    # shellcheck disable=SC2086
    local flagsArray=(
        $distFlags ${distFlagsArray+"${distFlagsArray[@]}"} ${distTarget:-dist}
    )

    echo 'dist flags: %q' "${flagsArray[@]}"
    make ${makefile:+-f $makefile} "${flagsArray[@]}"

    if [ "${dontCopyDist:-0}" != 1 ]; then
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
    if [ -f "${buildCommandPath:-}" ]; then
        local oldOpts="$(shopt -po nounset)"
        set +u
        source "$buildCommandPath"
        eval "$oldOpts"
        return
    fi
    if [ -n "${buildCommand:-}" ]; then
        local oldOpts="$(shopt -po nounset)"
        set +u
        eval "$buildCommand"
        eval "$oldOpts"
        return
    fi

    if [ -z "${phases:-}" ]; then
        phases="${prePhases:-} unpackPhase patchPhase ${preConfigurePhases:-} \
            configurePhase ${preBuildPhases:-} buildPhase checkPhase \
            ${preInstallPhases:-} installPhase ${preFixupPhases:-} fixupPhase installCheckPhase \
            ${preDistPhases:-} distPhase ${postPhases:-}";
    fi

    for curPhase in $phases; do
        if [[ "$curPhase" = buildPhase && -n "${dontBuild:-}" ]]; then continue; fi
        if [[ "$curPhase" = checkPhase && -z "${doCheck:-}" ]]; then continue; fi
        if [[ "$curPhase" = installPhase && -n "${dontInstall:-}" ]]; then continue; fi
        if [[ "$curPhase" = fixupPhase && -n "${dontFixup:-}" ]]; then continue; fi
        if [[ "$curPhase" = installCheckPhase && -z "${doInstallCheck:-}" ]]; then continue; fi
        if [[ "$curPhase" = distPhase && -z "${doDist:-}" ]]; then continue; fi

        if [[ -n $NIX_LOG_FD ]]; then
            echo "@nix { \"action\": \"setPhase\", \"phase\": \"$curPhase\" }" >&$NIX_LOG_FD
        fi

        showPhaseHeader "$curPhase"
        dumpVars

        # Evaluate the variable named $curPhase if it exists, otherwise the
        # function named $curPhase.
        local oldOpts="$(shopt -po nounset)"
        set +u
        eval "${!curPhase:-$curPhase}"
        eval "$oldOpts"

        if [ "$curPhase" = unpackPhase ]; then
            cd "${sourceRoot:-.}"
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

# Disable nounset for nix-shell.
set +u
