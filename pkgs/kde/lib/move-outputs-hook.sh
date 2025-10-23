# shellcheck shell=bash
# shellcheck disable=SC2154

moveKF6Outputs() {
    if [ -n "$devtools" ]; then
        mkdir -p "$devtools"
        moveToOutput "${qtPluginPrefix}/designer" "$devtools"
    fi

    if [ -n "$python" ]; then
        mkdir -p "$python"
        moveToOutput 'lib/python*' "$python"
        moveToOutput 'share/PySide6' "$python"
        moveToOutput 'include/PySide6' "$python"
    fi
}

postInstallHooks+=('moveKF6Outputs')
