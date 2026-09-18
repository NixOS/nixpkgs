# shellcheck shell=bash
# shellcheck disable=SC2154

declare -a NIXPKGS_KDE_PYTHON_DEPS

findKDEPythonDepsHook() {
  if [ -d "$1/share/PySide6/typesystems" ]; then
    NIXPKGS_KDE_PYTHON_DEPS+=("$1")
  fi
}
addEnvHooks "$targetOffset" findKDEPythonDepsHook

moveKF6Outputs() {
    if [ -n "$devtools" ]; then
        mkdir -p "$devtools"
        moveToOutput "${qtPluginPrefix}/designer" "$devtools"
    fi

    if [ -n "$python" ]; then
        mkdir -p "$python/nix-support"
        moveToOutput 'lib/python*' "$python"
        moveToOutput 'share/PySide6' "$python"
        moveToOutput 'include/PySide6' "$python"
        echo "${NIXPKGS_KDE_PYTHON_DEPS[@]}" > "$python/nix-support/propagated-build-inputs"
    fi
}

postInstallHooks+=('moveKF6Outputs')
