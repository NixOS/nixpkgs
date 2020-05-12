remove-path-dependencies-hook() {
    if ! test -f pyproject.toml; then
        return
    fi

    # Tell poetry not to resolve the path dependencies. Any version is fine!
    @yj@ -tj < pyproject.toml | @pythonInterpreter@ @pyprojectPatchScript@ > pyproject.json
    @yj@ -jt < pyproject.json > pyproject.toml
    rm pyproject.json
}

postPatchHooks+=(remove-path-dependencies-hook)
