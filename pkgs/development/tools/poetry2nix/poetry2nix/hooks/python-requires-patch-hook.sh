poetry2nix-python-requires-patch-hook() {
    if [ -z "${dontFixupPythonRequires-}" ]; then
        @pythonInterpreter@ @patchScript@ @pythonPath@
    fi
}

postPatchHooks+=(poetry2nix-python-requires-patch-hook)
