set -e

: ${outputs:=out}

######################################################################
# Initialisation.


# Wildcard expansions that don't match should expand to an empty list.
# This ensures that, for instance, "for i in *; do ...; done" does the
# right thing.
shopt -s nullglob


# Set up the initial path.
PATH=
for i in $initialPath; do
    if [ "$i" = / ]; then i=; fi
    addToSearchPath PATH $i/bin
    addToSearchPath PATH $i/sbin
done

if [ "$NIX_DEBUG" = 1 ]; then
    echo "initial path: $PATH"
fi

# Check that the pre-hook initialised SHELL.
if [ -z "$SHELL" ]; then echo "SHELL not set"; exit 1; fi

# Execute the pre-hook.
export CONFIG_SHELL="$SHELL"
if [ -z "$shell" ]; then export shell=$SHELL; fi


# Allow the caller to augment buildInputs (it's not always possible to
# do this before the call to setup.sh, since the PATH is empty at that
# point; here we have a basic Unix environment).
# Default: ../../build-support/setup-hooks/add-build-inputs.sh
runHook addInputsHook

addRpathPrefix "$out"

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


# FIXME: $_PATH is otherwise unreferenced, so its purpose is unclear.
PATH=$_PATH${_PATH:+:}$PATH
if [ "$NIX_DEBUG" = 1 ]; then
    echo "final path: $PATH"
fi


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


# Dummy implementation of the paxmark function. On Linux, this is
# overwritten by paxctl's setup hook.
paxmark() { true; }


######################################################################
# What follows is the generic builder.

genericBuild() {
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

# Execute the post-hooks.
runHook postHook

# Execute the global user hook (defined through the Nixpkgs
# configuration option ‘stdenv.userHook’).  This can be used to set
# global compiler optimisation flags, for instance.
runHook userHook

dumpVars

