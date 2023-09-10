remove-@kind@-dependencies-hook() {
    # Tell poetry not to resolve special dependencies. Any version is fine!

    if ! test -f pyproject.toml; then
        return
    fi

    echo "Removing @kind@ dependencies"

    # NOTE: We have to reset PYTHONPATH to avoid having propagatedBuildInputs
    # from the currently building derivation leaking into our unrelated Python
    # environment.
    PYTHONPATH=@pythonPath@ \
    @pythonInterpreter@ \
    @pyprojectPatchScript@ \
      --fields-to-remove @fields@ < pyproject.toml > pyproject.formatted.toml

    mv pyproject.formatted.toml pyproject.toml

    echo "Finished removing @kind@ dependencies"
}

postPatchHooks+=(remove-@kind@-dependencies-hook)
