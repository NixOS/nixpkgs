# Setup hook to check HA manifest requirements
echo "Sourcing manifest-requirements-check-hook"

function manifestCheckPhase() {
    echo "Executing manifestCheckPhase"
    runHook preCheck

    manifests=$(shopt -s nullglob; echo $out/custom_components/*/manifest.json)

    if [ ! -z "$manifests" ]; then
        echo Checking manifests $manifests
        @pythonCheckInterpreter@ @checkManifest@ $manifests
    else
        echo "No custom component manifests found in $out" >&2
        exit 1
    fi

    runHook postCheck
    echo "Finished executing manifestCheckPhase"
}

if [ -z "${dontCheckManifest-}" ] && [ -z "${installCheckPhase-}" ]; then
    echo "Using manifestCheckPhase"
    preDistPhases+=" manifestCheckPhase"
fi
