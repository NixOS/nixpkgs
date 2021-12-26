remove-@kind@-dependencies-hook() {
    if ! test -f pyproject.toml; then
        return
    fi

    echo "Removing @kind@ dependencies"

    # Tell poetry not to resolve special dependencies. Any version is fine!
    @yj@ -tj < pyproject.toml | \
        @pythonInterpreter@ \
        @pyprojectPatchScript@ \
        --fields-to-remove @fields@ > pyproject.json
    @yj@ -jt < pyproject.json > pyproject.toml

    rm pyproject.json

    echo "Finished removing @kind@ dependencies"
}

postPatchHooks+=(remove-@kind@-dependencies-hook)
