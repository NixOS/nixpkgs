# shellcheck shell=bash

# Setup hook to check HA manifest requirements
echo "Sourcing manifest-check-hook"

function manifestCheckPhase() {
    echo "Executing manifestCheckPhase"
    runHook preCheck

    args=""
    # shellcheck disable=SC2154
    for package in "${ignoreVersionRequirement[@]}"; do
        args+=" --ignore-version-requirement ${package}"
    done

    readarray -d '' manifests < <(
      find . -type f \( \
        -path ./manifest.json \
        -o -path './custom_components/*/manifest.json' \
        -o -path './custom_components/*/integrations/*/manifest.json' \
      \) -print0
    )

    if [ "${#manifests[@]}" -gt 0 ]; then
        # shellcheck disable=SC2068
        echo Checking manifests ${manifests[@]}
        # shellcheck disable=SC2068,SC2086
        @pythonCheckInterpreter@ @checkManifest@ ${manifests[@]} $args
    else
        # shellcheck disable=SC2154
        echo "No component manifests found in $out" >&2
        exit 1
    fi

    runHook postCheck
    echo "Finished executing manifestCheckPhase"
}

if [ -z "${dontCheckManifest-}" ] && [ -z "${installCheckPhase-}" ]; then
    echo "Using manifestCheckPhase"
    appendToVar preDistPhases manifestCheckPhase
fi
