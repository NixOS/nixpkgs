# shellcheck shell=bash
# shellcheck disable=SC2154

moveKF6DevTools() {
    if [ -n "$devtools" ]; then
        mkdir -p "$devtools"
        moveToOutput "${qtPluginPrefix}/designer" "$devtools"
    fi
}

postInstallHooks+=('moveKF6DevTools')
