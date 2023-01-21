# shellcheck shell=bash
# shellcheck disable=1090,2154,2123,2034,2178,2048,2068,1091
__nixpkgs_setup_set_original=$-
set -eu
set -o pipefail

if [[ -n "${BASH_VERSINFO-}" && "${BASH_VERSINFO-}" -lt 4 ]]; then
    echo "Detected Bash version that isn't supported by Nixpkgs (${BASH_VERSION})"
    echo "Please install Bash 4 or greater to continue."
    exit 1
fi

shopt -s inherit_errexit

if (( "${NIX_DEBUG:-0}" >= 6 )); then
    set -x
fi

if [ -f .attrs.sh ]; then
    __structuredAttrs=1
    echo "structuredAttrs is enabled"
else
    __structuredAttrs=
fi

if [ -n "$__structuredAttrs" ]; then
    for outputName in "${!outputs[@]}"; do
        # ex: out=/nix/store/...
        export "$outputName=${outputs[$outputName]}"
    done
    # $NIX_ATTRS_JSON_FILE points to the wrong location in sandbox
    # https://github.com/NixOS/nix/issues/6736
    export NIX_ATTRS_JSON_FILE="$NIX_BUILD_TOP/.attrs.json"
    export NIX_ATTRS_SH_FILE="$NIX_BUILD_TOP/.attrs.sh"
else
    : "${outputs:=out}"
fi

getAllOutputNames() {
    if [ -n "$__structuredAttrs" ]; then
        echo "${!outputs[*]}"
    else
        echo "$outputs"
    fi
}

######################################################################
# Hook handling.


# Run all hooks with the specified name in the order in which they
# were added, stopping if any fails (returns a non-zero exit
# code). The hooks for <hookName> are the shell function or variable
# <hookName>, and the values of the shell array ‘<hookName>Hooks’.
runHook() {
    local hookName="$1"
    shift
    local hooksSlice="${hookName%Hook}Hooks[@]"

    local hook
    # Hack around old bash being bad and thinking empty arrays are
    # undefined.
    for hook in "_callImplicitHook 0 $hookName" ${!hooksSlice+"${!hooksSlice}"}; do
        _eval "$hook" "$@"
    done

    return 0
}


# Run all hooks with the specified name, until one succeeds (returns a
# zero exit code). If none succeed, return a non-zero exit code.
runOneHook() {
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
    done

    return "$ret"
}


# Run the named hook, either by calling the function with that name or
# by evaluating the variable with that name. This allows convenient
# setting of hooks both from Nix expressions (as attributes /
# environment variables) and from shell scripts (as functions). If you
# want to allow multiple hooks, use runHook instead.
_callImplicitHook() {
    local def="$1"
    local hookName="$2"
    if declare -F "$hookName" > /dev/null; then
        "$hookName"
    elif type -p "$hookName" > /dev/null; then
        source "$hookName"
    elif [ -n "${!hookName:-}" ]; then
        eval "${!hookName}"
    else
        return "$def"
    fi
    # `_eval` expects hook to need nounset disable and leave it
    # disabled anyways, so Ok to to delegate. The alternative of a
    # return trap is no good because it would affect nested returns.
}


# A function wrapper around ‘eval’ that ensures that ‘return’ inside
# hooks exits the hook, not the caller. Also will only pass args if
# command can take them
_eval() {
    if declare -F "$1" > /dev/null 2>&1; then
        "$@" # including args
    else
        eval "$1"
    fi
}


######################################################################
# Logging.

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
        read -r -d '' -a buildTimes < <(times)
        echo "build times:"
        echo "user time for the shell             ${buildTimes[0]}"
        echo "system time for the shell           ${buildTimes[1]}"
        echo "user time for all child processes   ${buildTimes[2]}"
        echo "system time for all child processes ${buildTimes[3]}"
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

    return "$exitCode"
}

trap "exitHandler" EXIT


######################################################################
# Helper functions.


addToSearchPathWithCustomDelimiter() {
    local delimiter="$1"
    local varName="$2"
    local dir="$3"
    if [[ -d "$dir" && "${!varName:+${delimiter}${!varName}${delimiter}}" \
          != *"${delimiter}${dir}${delimiter}"* ]]; then
        export "${varName}=${!varName:+${!varName}${delimiter}}${dir}"
    fi
}

addToSearchPath() {
    addToSearchPathWithCustomDelimiter ":" "$@"
}

# Prepend elements to variable "$1", which may come from an attr.
#
# This is useful in generic setup code, which must (for now) support
# both derivations with and without __structuredAttrs true, so the
# variable may be an array or a space-separated string.
#
# Expressions for individual packages should simply switch to array
# syntax when they switch to setting __structuredAttrs = true.
prependToVar() {
    local -n nameref="$1"
    local useArray type

    if [ -n "$__structuredAttrs" ]; then
        useArray=true
    else
        useArray=false
    fi

    # check if variable already exist and if it does then do extra checks
    if declare -p "$1" 2> /dev/null | grep -q '^'; then
        type="$(declare -p "$1")"
        if [[ "$type" =~ "declare -A" ]]; then
            echo "prependToVar(): ERROR: trying to use prependToVar on an associative array." >&2
            return 1
        elif [[ "$type" =~ "declare -a" ]]; then
            useArray=true
        else
            useArray=false
        fi
    fi

    shift

    if $useArray; then
        nameref=( "$@" ${nameref+"${nameref[@]}"} )
    else
        nameref="$* ${nameref-}"
    fi
}

# Same as above
appendToVar() {
    local -n nameref="$1"
    local useArray type

    if [ -n "$__structuredAttrs" ]; then
        useArray=true
    else
        useArray=false
    fi

    # check if variable already exist and if it does then do extra checks
    if declare -p "$1" 2> /dev/null | grep -q '^'; then
        type="$(declare -p "$1")"
        if [[ "$type" =~ "declare -A" ]]; then
            echo "appendToVar(): ERROR: trying to use appendToVar on an associative array, use variable+=([\"X\"]=\"Y\") instead." >&2
            return 1
        elif [[ "$type" =~ "declare -a" ]]; then
            useArray=true
        else
            useArray=false
        fi
    fi

    shift

    if $useArray; then
        nameref=( ${nameref+"${nameref[@]}"} "$@" )
    else
        nameref="${nameref-} $*"
    fi
}

# Accumulate into `flagsArray` the flags from the named variables.
#
# If __structuredAttrs, the variables are all treated as arrays
# and simply concatenated onto `flagsArray`.
#
# If not __structuredAttrs, then:
#   * Each variable is treated as a string, and split on whitespace;
#   * except variables whose names end in "Array", which are treated
#     as arrays.
_accumFlagsArray() {
    local name
    if [ -n "$__structuredAttrs" ]; then
        for name in "$@"; do
            local -n nameref="$name"
            flagsArray+=( ${nameref+"${nameref[@]}"} )
        done
    else
        for name in "$@"; do
            local -n nameref="$name"
            case "$name" in
                *Array)
                    flagsArray+=( ${nameref+"${nameref[@]}"} ) ;;
                *)
                    flagsArray+=( ${nameref-} ) ;;
            esac
        done
    fi

}

# Add $1/lib* into rpaths.
# The function is used in multiple-outputs.sh hook,
# so it is defined here but tried after the hook.
_addRpathPrefix() {
    if [ "${NIX_NO_SELF_RPATH:-0}" != 1 ]; then
        export NIX_LDFLAGS="-rpath $1/lib ${NIX_LDFLAGS-}"
        if [ -n "${NIX_LIB64_IN_SELF_RPATH:-}" ]; then
            export NIX_LDFLAGS="-rpath $1/lib64 ${NIX_LDFLAGS-}"
        fi
        if [ -n "${NIX_LIB32_IN_SELF_RPATH:-}" ]; then
            export NIX_LDFLAGS="-rpath $1/lib32 ${NIX_LDFLAGS-}"
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
    if [ "$magic" = $'\177ELF' ]; then return 0; else return 1; fi
}

# Return success if the specified file is a Mach-O object.
isMachO() {
    local fn="$1"
    local fd
    local magic
    exec {fd}< "$fn"
    read -r -n 4 -u "$fd" magic
    exec {fd}<&-

    # nix uses 'declare -F' in get-env.sh to retrieve the loaded functions.
    # If we use the $'string' syntax instead of 'echo -ne' then 'declare' will print the raw characters and break nix.
    # See https://github.com/NixOS/nixpkgs/pull/138334 and https://github.com/NixOS/nix/issues/5262.

    # https://opensource.apple.com/source/lldb/lldb-310.2.36/examples/python/mach_o.py.auto.html
    if [[ "$magic" = $(echo -ne "\xfe\xed\xfa\xcf") || "$magic" = $(echo -ne "\xcf\xfa\xed\xfe") ]]; then
        # MH_MAGIC_64 || MH_CIGAM_64
        return 0;
    elif [[ "$magic" = $(echo -ne "\xfe\xed\xfa\xce") || "$magic" = $(echo -ne "\xce\xfa\xed\xfe") ]]; then
        # MH_MAGIC || MH_CIGAM
        return 0;
    elif [[ "$magic" = $(echo -ne "\xca\xfe\xba\xbe") || "$magic" = $(echo -ne "\xbe\xba\xfe\xca") ]]; then
        # FAT_MAGIC || FAT_CIGAM
        return 0;
    else
        return 1;
    fi
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

# If using structured attributes, export variables from `env` to the environment.
# When not using structured attributes, those variables are already exported.
if [[ -n $__structuredAttrs ]]; then
    for envVar in "${!env[@]}"; do
        declare -x "${envVar}=${env[${envVar}]}"
    done
fi


# Set a fallback default value for SOURCE_DATE_EPOCH, used by some build tools
# to provide a deterministic substitute for the "current" time. Note that
# 315532800 = 1980-01-01 12:00:00. We use this date because python's wheel
# implementation uses zip archive and zip does not support dates going back to
# 1970.
export SOURCE_DATE_EPOCH
: "${SOURCE_DATE_EPOCH:=315532800}"


# Wildcard expansions that don't match should expand to an empty list.
# This ensures that, for instance, "for i in *; do ...; done" does the
# right thing.
shopt -s nullglob


# Set up the initial path.
PATH=
HOST_PATH=
for i in $initialPath; do
    if [ "$i" = / ]; then i=; fi
    addToSearchPath PATH "$i/bin"

    # For backward compatibility, we add initial path to HOST_PATH so
    # it can be used in auto patch-shebangs. Unfortunately this will
    # not work with cross compilation.
    if [ -z "${strictDeps-}" ]; then
        addToSearchPath HOST_PATH "$i/bin"
    fi
done

unset i

if (( "${NIX_DEBUG:-0}" >= 1 )); then
    echo "initial path: $PATH"
fi


# Check that the pre-hook initialised SHELL.
if [ -z "${SHELL:-}" ]; then echo "SHELL not set"; exit 1; fi
BASH="$SHELL"
export CONFIG_SHELL="$SHELL"


# Execute the pre-hook.
if [ -z "${shell:-}" ]; then export shell="$SHELL"; fi
runHook preHook


# Allow the caller to augment buildInputs (it's not always possible to
# do this before the call to setup.sh, since the PATH is empty at that
# point; here we have a basic Unix environment).
runHook addInputsHook


# Package accumulators

declare -a pkgsBuildBuild pkgsBuildHost pkgsBuildTarget
declare -a pkgsHostHost pkgsHostTarget
declare -a pkgsTargetTarget

declare -a pkgBuildAccumVars=(pkgsBuildBuild pkgsBuildHost pkgsBuildTarget)
declare -a pkgHostAccumVars=(pkgsHostHost pkgsHostTarget)
declare -a pkgTargetAccumVars=(pkgsTargetTarget)

declare -a pkgAccumVarVars=(pkgBuildAccumVars pkgHostAccumVars pkgTargetAccumVars)


# Hooks

declare -a envBuildBuildHooks envBuildHostHooks envBuildTargetHooks
declare -a envHostHostHooks envHostTargetHooks
declare -a envTargetTargetHooks

declare -a pkgBuildHookVars=(envBuildBuildHook envBuildHostHook envBuildTargetHook)
declare -a pkgHostHookVars=(envHostHostHook envHostTargetHook)
declare -a pkgTargetHookVars=(envTargetTargetHook)

declare -a pkgHookVarVars=(pkgBuildHookVars pkgHostHookVars pkgTargetHookVars)

# those variables are declared here, since where and if they are used varies
declare -a preFixupHooks fixupOutputHooks preConfigureHooks postFixupHooks postUnpackHooks unpackCmdHooks

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

declare -a propagatedBuildDepFiles=(
    propagated-build-build-deps
    propagated-native-build-inputs # Legacy name for back-compat
    propagated-build-target-deps
)
declare -a propagatedHostDepFiles=(
    propagated-host-host-deps
    propagated-build-inputs # Legacy name for back-compat
)
declare -a propagatedTargetDepFiles=(
    propagated-target-target-deps
)
declare -a propagatedDepFilesVars=(
    propagatedBuildDepFiles
    propagatedHostDepFiles
    propagatedTargetDepFiles
)

# Platform offsets: build = -1, host = 0, target = 1
declare -a allPlatOffsets=(-1 0 1)


# Mutually-recursively find all build inputs. See the dependency section of the
# stdenv chapter of the Nixpkgs manual for the specification this algorithm
# implements.
findInputs() {
    local -r pkg="$1"
    local -r hostOffset="$2"
    local -r targetOffset="$3"

    # Sanity check
    (( hostOffset <= targetOffset )) || exit 1

    local varVar="${pkgAccumVarVars[hostOffset + 1]}"
    local varRef="$varVar[$((targetOffset - hostOffset))]"
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
        local -r inputOffset="$1"
        local -n outputOffset="$2"
        if (( inputOffset <= 0 )); then
            outputOffset=$((inputOffset + hostOffset))
        else
            outputOffset=$((inputOffset - 1 + targetOffset))
        fi
    }

    # Host offset relative to that of the package whose immediate
    # dependencies we are currently exploring.
    local relHostOffset
    for relHostOffset in "${allPlatOffsets[@]}"; do
        # `+ 1` so we start at 0 for valid index
        local files="${propagatedDepFilesVars[relHostOffset + 1]}"

        # Host offset relative to the package currently being
        # built---as absolute an offset as will be used.
        local hostOffsetNext
        mapOffset "$relHostOffset" hostOffsetNext

        # Ensure we're in bounds relative to the package currently
        # being built.
        (( -1 <= hostOffsetNext && hostOffsetNext <= 1 )) || continue

        # Target offset relative to the *host* offset of the package
        # whose immediate dependencies we are currently exploring.
        local relTargetOffset
        for relTargetOffset in "${allPlatOffsets[@]}"; do
            (( "$relHostOffset" <= "$relTargetOffset" )) || continue

            local fileRef="${files}[$relTargetOffset - $relHostOffset]"
            local file="${!fileRef}"
            unset -v fileRef

            # Target offset relative to the package currently being
            # built.
            local targetOffsetNext
            mapOffset "$relTargetOffset" targetOffsetNext

            # Once again, ensure we're in bounds relative to the
            # package currently being built.
            (( -1 <= hostOffsetNext && hostOffsetNext <= 1 )) || continue

            [[ -f "$pkg/nix-support/$file" ]] || continue

            local pkgNext
            read -r -d '' pkgNext < "$pkg/nix-support/$file" || true
            for pkgNext in $pkgNext; do
                findInputs "$pkgNext" "$hostOffsetNext" "$targetOffsetNext"
            done
        done
    done
}

# The way we handle deps* and *Inputs works with structured attrs
# either enabled or disabled.  For this it's convenient that the items
# in each list must be store paths, and therefore space-free.

# Make sure all are at least defined as empty
: "${depsBuildBuild=}" "${depsBuildBuildPropagated=}"
: "${nativeBuildInputs=}" "${propagatedNativeBuildInputs=}" "${defaultNativeBuildInputs=}"
: "${depsBuildTarget=}" "${depsBuildTargetPropagated=}"
: "${depsHostHost=}" "${depsHostHostPropagated=}"
: "${buildInputs=}" "${propagatedBuildInputs=}" "${defaultBuildInputs=}"
: "${depsTargetTarget=}" "${depsTargetTargetPropagated=}"

for pkg in ${depsBuildBuild[@]} ${depsBuildBuildPropagated[@]}; do
    findInputs "$pkg" -1 -1
done
for pkg in ${nativeBuildInputs[@]} ${propagatedNativeBuildInputs[@]}; do
    findInputs "$pkg" -1  0
done
for pkg in ${depsBuildTarget[@]} ${depsBuildTargetPropagated[@]}; do
    findInputs "$pkg" -1  1
done
for pkg in ${depsHostHost[@]} ${depsHostHostPropagated[@]}; do
    findInputs "$pkg"  0  0
done
for pkg in ${buildInputs[@]} ${propagatedBuildInputs[@]} ; do
    findInputs "$pkg"  0  1
done
for pkg in ${depsTargetTarget[@]} ${depsTargetTargetPropagated[@]}; do
    findInputs "$pkg"  1  1
done
# Default inputs must be processed last
for pkg in ${defaultNativeBuildInputs[@]}; do
    findInputs "$pkg" -1  0
done
for pkg in ${defaultBuildInputs[@]}; do
    findInputs "$pkg"  0  1
done

# Add package to the future PATH and run setup hooks
activatePackage() {
    local pkg="$1"
    local -r hostOffset="$2"
    local -r targetOffset="$3"

    # Sanity check
    (( hostOffset <= targetOffset )) || exit 1

    if [ -f "$pkg" ]; then
        source "$pkg"
    fi

    # Only dependencies whose host platform is guaranteed to match the
    # build platform are included here. That would be `depsBuild*`,
    # and legacy `nativeBuildInputs`, in general. If we aren't cross
    # compiling, however, everything can be put on the PATH. To ease
    # the transition, we do include everything in that case.
    #
    # TODO(@Ericson2314): Don't special-case native compilation
    if [[ -z "${strictDeps-}" || "$hostOffset" -le -1 ]]; then
        addToSearchPath _PATH "$pkg/bin"
    fi

    if (( hostOffset <= -1 )); then
        addToSearchPath _XDG_DATA_DIRS "$pkg/share"
    fi

    if [[ "$hostOffset" -eq 0 && -d "$pkg/bin" ]]; then
        addToSearchPath _HOST_PATH "$pkg/bin"
    fi

    if [[ -f "$pkg/nix-support/setup-hook" ]]; then
        source "$pkg/nix-support/setup-hook"
    fi
}

_activatePkgs() {
    local hostOffset targetOffset
    local pkg

    for hostOffset in "${allPlatOffsets[@]}"; do
        local pkgsVar="${pkgAccumVarVars[hostOffset + 1]}"
        for targetOffset in "${allPlatOffsets[@]}"; do
            (( hostOffset <= targetOffset )) || continue
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
    local depHostOffset depTargetOffset
    local pkg

    for depHostOffset in "${allPlatOffsets[@]}"; do
        local hookVar="${pkgHookVarVars[depHostOffset + 1]}"
        local pkgsVar="${pkgAccumVarVars[depHostOffset + 1]}"
        for depTargetOffset in "${allPlatOffsets[@]}"; do
            (( depHostOffset <= depTargetOffset )) || continue
            local hookRef="${hookVar}[$depTargetOffset - $depHostOffset]"
            if [[ -z "${strictDeps-}" ]]; then

                # Keep track of which packages we have visited before.
                local visitedPkgs=""

                # Apply environment hooks to all packages during native
                # compilation to ease the transition.
                #
                # TODO(@Ericson2314): Don't special-case native compilation
                for pkg in \
                    "${pkgsBuildBuild[@]}" \
                    "${pkgsBuildHost[@]}" \
                    "${pkgsBuildTarget[@]}" \
                    "${pkgsHostHost[@]}" \
                    "${pkgsHostTarget[@]}" \
                    "${pkgsTargetTarget[@]}"
                do
                    if [[ "$visitedPkgs" = *"$pkg"* ]]; then
                        continue
                    fi
                    runHook "${!hookRef}" "$pkg"
                    visitedPkgs+=" $pkg"
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


# Unset setup-specific declared variables
unset allPlatOffsets
unset pkgBuildAccumVars pkgHostAccumVars pkgTargetAccumVars pkgAccumVarVars
unset pkgBuildHookVars pkgHostHookVars pkgTargetHookVars pkgHookVarVars
unset propagatedDepFilesVars


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
HOST_PATH="${_HOST_PATH-}${_HOST_PATH:+${HOST_PATH:+:}}$HOST_PATH"
export XDG_DATA_DIRS="${_XDG_DATA_DIRS-}${_XDG_DATA_DIRS:+${XDG_DATA_DIRS:+:}}${XDG_DATA_DIRS-}"
if (( "${NIX_DEBUG:-0}" >= 1 )); then
    echo "final path: $PATH"
    echo "final host path: $HOST_PATH"
    echo "final data dirs: $XDG_DATA_DIRS"
fi

unset _PATH
unset _HOST_PATH
unset _XDG_DATA_DIRS


# Normalize the NIX_BUILD_CORES variable. The value might be 0, which
# means that we're supposed to try and auto-detect the number of
# available CPU cores at run-time.

NIX_BUILD_CORES="${NIX_BUILD_CORES:-1}"
if ((NIX_BUILD_CORES <= 0)); then
  guess=$(nproc 2>/dev/null || true)
  ((NIX_BUILD_CORES = guess <= 0 ? 1 : guess))
fi
export NIX_BUILD_CORES


# Prevent SSL libraries from using certificates in /etc/ssl, unless set explicitly.
# Leave it in impure shells for convenience.
if [[ -z "${NIX_SSL_CERT_FILE:-}" && "${IN_NIX_SHELL:-}" != "impure" ]]; then
  export NIX_SSL_CERT_FILE=/no-cert-file.crt
fi
# Another variant left for compatibility.
if [[ -z "${SSL_CERT_FILE:-}" && "${IN_NIX_SHELL:-}" != "impure" ]]; then
  export SSL_CERT_FILE=/no-cert-file.crt
fi


######################################################################
# Textual substitution functions.


substituteStream() {
    local var=$1
    local description=$2
    shift 2

    while (( "$#" )); do
        case "$1" in
            --replace)
                pattern="$2"
                replacement="$3"
                shift 3
                local savedvar
                savedvar="${!var}"
                eval "$var"'=${'"$var"'//"$pattern"/"$replacement"}'
                if [ "$pattern" != "$replacement" ]; then
                    if [ "${!var}" == "$savedvar" ]; then
                        echo "substituteStream(): WARNING: pattern '$pattern' doesn't match anything in $description" >&2
                    fi
                fi
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
                eval "$var"'=${'"$var"'//"$pattern"/"$replacement"}'
                ;;

            --subst-var-by)
                pattern="@$2@"
                replacement="$3"
                eval "$var"'=${'"$var"'//"$pattern"/"$replacement"}'
                shift 3
                ;;

            *)
                echo "substituteStream(): ERROR: Invalid command line argument: $1" >&2
                return 1
                ;;
        esac
    done

    printf "%s" "${!var}"
}

# put the content of a file in a variable
# fail loudly if provided with a binary (containing null bytes)
consumeEntire() {
    # read returns non-0 on EOF, so we want read to fail
    if IFS='' read -r -d '' "$1" ; then
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
    substituteStream content "file '$input'" "$@" > "$output"
}

substituteInPlace() {
    local -a fileNames=()
    for arg in "$@"; do
        if [[ "$arg" = "--"* ]]; then
            break
        fi
        fileNames+=("$arg")
        shift
    done

    for file in "${fileNames[@]}"; do
        substitute "$file" "$file" "$@"
    done
}

_allFlags() {
    # export some local variables for the awk below
    # so some substitutions such as name don't have to be in the env attrset
    # when __structuredAttrs is enabled
    export system pname name version
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

    substituteStream "$1" "$2" "${args[@]}"
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
        export 2>/dev/null >| "$NIX_BUILD_TOP/env-vars" || true
    fi
}


# Utility function: echo the base name of the given path, with the
# prefix `HASH-' removed, if present.
stripHash() {
    local strippedName casematchOpt=0
    # On separate line for `set -e`
    strippedName="$(basename -- "$1")"
    shopt -q nocasematch && casematchOpt=1
    shopt -u nocasematch
    if [[ "$strippedName" =~ ^[a-z0-9]{32}- ]]; then
        echo "${strippedName:33}"
    else
        echo "$strippedName"
    fi
    if (( casematchOpt )); then shopt -s nocasematch; fi
}


unpackCmdHooks+=(_defaultUnpack)
_defaultUnpack() {
    local fn="$1"
    local destination

    if [ -d "$fn" ]; then

        destination="$(stripHash "$fn")"

        if [ -e "$destination" ]; then
            echo "Cannot copy $fn to $destination: destination already exists!"
            echo "Did you specify two \"srcs\" with the same \"name\"?"
            return 1
        fi

        # We can't preserve hardlinks because they may have been
        # introduced by store optimization, which might break things
        # in the build.
        cp -pr --reflink=auto -- "$fn" "$destination"

    else

        case "$fn" in
            *.tar.xz | *.tar.lzma | *.txz)
                # Don't rely on tar knowing about .xz.
                xz -d < "$fn" | tar xf - --warning=no-timestamp
                ;;
            *.tar | *.tar.* | *.tgz | *.tbz2 | *.tbz)
                # GNU tar can automatically select the decompression method
                # (info "(tar) gzip").
                tar xf "$fn" --warning=no-timestamp
                ;;
            *)
                return 1
                ;;
        esac

    fi
}


unpackFile() {
    curSrc="$1"
    echo "unpacking source archive $curSrc"
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

    local -a srcsArray
    if [ -n "$__structuredAttrs" ]; then
        srcsArray=( "${srcs[@]}" )
    else
        srcsArray=( $srcs )
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
    for i in "${srcsArray[@]}"; do
        unpackFile "$i"
    done

    # Find the source directory.

    # set to empty if unset
    : "${sourceRoot=}"

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

    local -a patchesArray
    if [ -n "$__structuredAttrs" ]; then
        patchesArray=( ${patches:+"${patches[@]}"} )
    else
        patchesArray=( ${patches:-} )
    fi

    for i in "${patchesArray[@]}"; do
        echo "applying patch $i"
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

        local -a flagsArray
        if [ -n "$__structuredAttrs" ]; then
            flagsArray=( "${patchFlags[@]:--p1}" )
        else
            # shellcheck disable=SC2086
            flagsArray=( ${patchFlags:--p1} )
        fi
        # "2>&1" is a hack to make patch fail if the decompressor fails (nonexistent patch, etc.)
        # shellcheck disable=SC2086
        $uncompress < "$i" 2>&1 | patch "${flagsArray[@]}"
    done

    runHook postPatch
}


fixLibtool() {
    local search_path
    for flag in $NIX_LDFLAGS; do
        case $flag in
            -L*)
                search_path+=" ${flag#-L}"
                ;;
        esac
    done

    sed -i "$1" \
        -e "s^eval \(sys_lib_search_path=\).*^\1'$search_path'^" \
        -e 's^eval sys_lib_.+search_path=.*^^'
}


configurePhase() {
    runHook preConfigure

    # set to empty if unset
    : "${configureScript=}"

    if [[ -z "$configureScript" && -x ./configure ]]; then
        configureScript=./configure
    fi

    if [ -z "${dontFixLibtool:-}" ]; then
        export lt_cv_deplibs_check_method="${lt_cv_deplibs_check_method-pass_all}"
        local i
        find . -iname "ltmain.sh" -print0 | while IFS='' read -r -d '' i; do
            echo "fixing libtool script $i"
            fixLibtool "$i"
        done

        # replace `/usr/bin/file` with `file` in any `configure`
        # scripts with vendored libtool code.  Preserve mtimes to
        # prevent some packages (e.g. libidn2) from spontaneously
        # autoreconf'ing themselves
        CONFIGURE_MTIME_REFERENCE=$(mktemp configure.mtime.reference.XXXXXX)
        find . \
          -executable \
          -type f \
          -name configure \
          -exec grep -l 'GNU Libtool is free software; you can redistribute it and/or modify' {} \; \
          -exec touch -r {} "$CONFIGURE_MTIME_REFERENCE" \; \
          -exec sed -i s_/usr/bin/file_file_g {} \;    \
          -exec touch -r "$CONFIGURE_MTIME_REFERENCE" {} \;
        rm -f "$CONFIGURE_MTIME_REFERENCE"
    fi

    if [[ -z "${dontAddPrefix:-}" && -n "$prefix" ]]; then
        prependToVar configureFlags "${prefixKey:---prefix=}$prefix"
    fi

    if [[ -f "$configureScript" ]]; then
        # Add --disable-dependency-tracking to speed up some builds.
        if [ -z "${dontAddDisableDepTrack:-}" ]; then
            if grep -q dependency-tracking "$configureScript"; then
                prependToVar configureFlags --disable-dependency-tracking
            fi
        fi

        # By default, disable static builds.
        if [ -z "${dontDisableStatic:-}" ]; then
            if grep -q enable-static "$configureScript"; then
                prependToVar configureFlags --disable-static
            fi
        fi
    fi

    if [ -n "$configureScript" ]; then
        local -a flagsArray
        _accumFlagsArray configureFlags configureFlagsArray

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

    if [[ -z "${makeFlags-}" && -z "${makefile:-}" && ! ( -e Makefile || -e makefile || -e GNUmakefile ) ]]; then
        echo "no Makefile or custom buildPhase, doing nothing"
    else
        foundMakefile=1

        # shellcheck disable=SC2086
        local flagsArray=(
            ${enableParallelBuilding:+-j${NIX_BUILD_CORES}}
            SHELL=$SHELL
        )
        _accumFlagsArray makeFlags makeFlagsArray buildFlags buildFlagsArray

        echoCmd 'build flags' "${flagsArray[@]}"
        make ${makefile:+-f $makefile} "${flagsArray[@]}"
        unset flagsArray
    fi

    runHook postBuild
}


checkPhase() {
    runHook preCheck

    if [[ -z "${foundMakefile:-}" ]]; then
        echo "no Makefile or custom checkPhase, doing nothing"
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
            ${enableParallelChecking:+-j${NIX_BUILD_CORES}}
            SHELL=$SHELL
        )

        _accumFlagsArray makeFlags makeFlagsArray
        if [ -n "$__structuredAttrs" ]; then
            flagsArray+=( "${checkFlags[@]:-VERBOSE=y}" )
        else
            flagsArray+=( ${checkFlags:-VERBOSE=y} )
        fi
        _accumFlagsArray checkFlagsArray
        flagsArray+=( ${checkTarget} )

        echoCmd 'check flags' "${flagsArray[@]}"
        make ${makefile:+-f $makefile} "${flagsArray[@]}"

        unset flagsArray
    fi

    runHook postCheck
}


installPhase() {
    runHook preInstall

    # Dont reuse 'foundMakefile' set in buildPhase, a makefile may have been created in buildPhase
    if [[ -z "${makeFlags-}" && -z "${makefile:-}" && ! ( -e Makefile || -e makefile || -e GNUmakefile ) ]]; then
        echo "no Makefile or custom installPhase, doing nothing"
        runHook postInstall
        return
    else
        foundMakefile=1
    fi

    if [ -n "$prefix" ]; then
        mkdir -p "$prefix"
    fi

    # shellcheck disable=SC2086
    local flagsArray=(
        SHELL=$SHELL
    )
    _accumFlagsArray makeFlags makeFlagsArray installFlags installFlagsArray
    if [ -n "$__structuredAttrs" ]; then
        flagsArray+=( "${installTargets[@]:-install}" )
    else
        flagsArray+=( ${installTargets:-install} )
    fi

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
    for output in $(getAllOutputNames); do
        if [ -e "${!output}" ]; then chmod -R u+w "${!output}"; fi
    done

    runHook preFixup

    # Apply fixup to each output.
    local output
    for output in $(getAllOutputNames); do
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
        # have to use ${setupHooks[@]} without quotes because it needs to support setupHooks being a array or a whitespace separated string
        # # values of setupHooks won't have spaces so it won't cause problems
        # shellcheck disable=2068
        for hook in ${setupHooks[@]}; do
            local content
            consumeEntire content < "$hook"
            substituteAllStream content "file '$hook'" >> "${!outputDev}/nix-support/setup-hook"
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
        echo "no Makefile or custom installCheckPhase, doing nothing"
    #TODO(@oxij): should flagsArray influence make -n?
    elif [[ -z "${installCheckTarget:-}" ]] \
       && ! make -n ${makefile:+-f $makefile} "${installCheckTarget:-installcheck}" >/dev/null 2>&1; then
        echo "no installcheck target in ${makefile:-Makefile}, doing nothing"
    else
        # Old bash empty array hack
        # shellcheck disable=SC2086
        local flagsArray=(
            ${enableParallelChecking:+-j${NIX_BUILD_CORES}}
            SHELL=$SHELL
        )

        _accumFlagsArray makeFlags makeFlagsArray \
          installCheckFlags installCheckFlagsArray
        flagsArray+=( ${installCheckTarget:-installcheck} )

        echoCmd 'installcheck flags' "${flagsArray[@]}"
        make ${makefile:+-f $makefile} "${flagsArray[@]}"
        unset flagsArray
    fi

    runHook postInstallCheck
}


distPhase() {
    runHook preDist

    local flagsArray=()
    _accumFlagsArray distFlags distFlagsArray
    flagsArray+=( ${distTarget:-dist} )

    echo 'dist flags: %q' "${flagsArray[@]}"
    make ${makefile:+-f $makefile} "${flagsArray[@]}"

    if [ "${dontCopyDist:-0}" != 1 ]; then
        mkdir -p "$out/tarballs"

        # Note: don't quote $tarballs, since we explicitly permit
        # wildcards in there.
        # shellcheck disable=SC2086
        cp -pvd ${tarballs[*]:-*.tar.gz} "$out/tarballs"
    fi

    runHook postDist
}


showPhaseHeader() {
    local phase="$1"
    case "$phase" in
        unpackPhase) echo "unpacking sources";;
        patchPhase) echo "patching sources";;
        configurePhase) echo "configuring";;
        buildPhase) echo "building";;
        checkPhase) echo "running tests";;
        installPhase) echo "installing";;
        fixupPhase) echo "post-installation fixup";;
        installCheckPhase) echo "running install tests";;
        *) echo "$phase";;
    esac
}


showPhaseFooter() {
    local phase="$1"
    local startTime="$2"
    local endTime="$3"
    local delta=$(( endTime - startTime ))
    (( delta < 30 )) && return

    local H=$((delta/3600))
    local M=$((delta%3600/60))
    local S=$((delta%60))
    echo -n "$phase completed in "
    (( H > 0 )) && echo -n "$H hours "
    (( M > 0 )) && echo -n "$M minutes "
    echo "$S seconds"
}


genericBuild() {
    # variable used by our gzip wrapper to add -n.
    # gzip is in common-path.nix and is added to nix-shell but we only want to change its behaviour in nix builds. do not move to a setupHook in gzip.
    export GZIP_NO_TIMESTAMPS=1

    if [ -f "${buildCommandPath:-}" ]; then
        source "$buildCommandPath"
        return
    fi
    if [ -n "${buildCommand:-}" ]; then
        eval "$buildCommand"
        return
    fi

    if [ -z "${phases[*]:-}" ]; then
        phases="${prePhases[*]:-} unpackPhase patchPhase ${preConfigurePhases[*]:-} \
            configurePhase ${preBuildPhases[*]:-} buildPhase checkPhase \
            ${preInstallPhases[*]:-} installPhase ${preFixupPhases[*]:-} fixupPhase installCheckPhase \
            ${preDistPhases[*]:-} distPhase ${postPhases[*]:-}";
    fi

    # The use of ${phases[*]} gives the correct behavior both with and
    # without structured attrs.  This relies on the fact that each
    # phase name is space-free, which it must be because it's the name
    # of either a shell variable or a shell function.
    for curPhase in ${phases[*]}; do
        if [[ "$curPhase" = unpackPhase && -n "${dontUnpack:-}" ]]; then continue; fi
        if [[ "$curPhase" = patchPhase && -n "${dontPatch:-}" ]]; then continue; fi
        if [[ "$curPhase" = configurePhase && -n "${dontConfigure:-}" ]]; then continue; fi
        if [[ "$curPhase" = buildPhase && -n "${dontBuild:-}" ]]; then continue; fi
        if [[ "$curPhase" = checkPhase && -z "${doCheck:-}" ]]; then continue; fi
        if [[ "$curPhase" = installPhase && -n "${dontInstall:-}" ]]; then continue; fi
        if [[ "$curPhase" = fixupPhase && -n "${dontFixup:-}" ]]; then continue; fi
        if [[ "$curPhase" = installCheckPhase && -z "${doInstallCheck:-}" ]]; then continue; fi
        if [[ "$curPhase" = distPhase && -z "${doDist:-}" ]]; then continue; fi

        if [[ -n $NIX_LOG_FD ]]; then
            echo "@nix { \"action\": \"setPhase\", \"phase\": \"$curPhase\" }" >&"$NIX_LOG_FD"
        fi

        showPhaseHeader "$curPhase"
        dumpVars

        local startTime=$(date +"%s")

        # Evaluate the variable named $curPhase if it exists, otherwise the
        # function named $curPhase.
        eval "${!curPhase:-$curPhase}"

        local endTime=$(date +"%s")

        showPhaseFooter "$curPhase" "$startTime" "$endTime"

        if [ "$curPhase" = unpackPhase ]; then
            # make sure we can cd into the directory
            [ -z "${sourceRoot}" ] || chmod +x "${sourceRoot}"

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


# Restore the original options for nix-shell
[[ $__nixpkgs_setup_set_original == *e* ]] || set +e
[[ $__nixpkgs_setup_set_original == *u* ]] || set +u
unset -v __nixpkgs_setup_set_original
