######################################################################
# handling build inputs

addInputsHooks+=(_defaultAddInputs)

# Find build inputs, including propagated ones, and execute their setupHooks.
# For the purpose of cross-compilation, each input can be "native" and/or "cross";
# when not cross-building, all inputs are considered "native".
_defaultAddInputs() {
    crossPkgs=""
    for i in $buildInputs $propagatedBuildInputs; do
        findInputs $i crossPkgs propagated-build-inputs
    done

    nativePkgs=""
    for i in $nativeBuildInputs $propagatedNativeBuildInputs; do
        findInputs $i nativePkgs propagated-native-build-inputs
    done

    for i in $nativePkgs; do
        _addToNativeEnv $i
    done

    for i in $crossPkgs; do
        _addToCrossEnv $i
    done
}

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

    if [ -f $pkg ]; then
        source $pkg
    fi

    if [ -f $pkg/nix-support/setup-hook ]; then
        source $pkg/nix-support/setup-hook
    fi

    if [ -f $pkg/nix-support/$propagatedBuildInputsFile ]; then
        for i in $(cat $pkg/nix-support/$propagatedBuildInputsFile); do
            findInputs $i $var $propagatedBuildInputsFile
        done
    fi
}

# Set the relevant environment variables to point to the build inputs
# found above.
_addToNativeEnv() {
    local pkg=$1

    if [ -d $1/bin ]; then
        addToSearchPath _PATH $1/bin
    fi

    # Run the package-specific hooks set by the setup-hook scripts.
    runHook envHook "$pkg"
}

_addToCrossEnv() {
    local pkg=$1

    # Some programs put important build scripts (freetype-config and similar)
    # into their crossDrv bin path. Intentionally these should go after
    # the nativePkgs in PATH.
    if [ -d $1/bin ]; then
        addToSearchPath _PATH $1/bin
    fi

    # Run the package-specific hooks set by the setup-hook scripts.
    runHook crossEnvHook "$pkg"
}


