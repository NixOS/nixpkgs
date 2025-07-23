# shellcheck shell=bash
qmlHostPathSeen=()
qmlIncludeDirs=()

qmlUnseenHostPath() {
    for pkg in "${qmlHostPathSeen[@]}"; do
        if [ "${pkg:?}" == "$1" ]; then
            return 1
        fi
    done

    qtHostPathSeen+=("$1")
    return 0
}

qmlHostPathHook() {
    qmlUnseenHostPath "$1" || return 0

    if ! [ -v qtQmlPrefix ]; then
        echo "qmlLintHook: qtQmlPrefix is unset. hint: add qt6.qtbase to buildInputs"
    fi

    local qmlDir="$1/${qtQmlPrefix:?}"
    if [ -d "$qmlDir" ]; then
        qmlIncludeDirs+=("-I" "$qmlDir")
    fi
}
addEnvHooks "$targetOffset" qmlHostPathHook

doQmlLint() {
    LANG=C.UTF-8 @qmllint@ --bare "${qmlIncludeDirs[@]}" -I "${out}/${qtQmlPrefix}" "$@"
}

qmlLintCheck() {
    echo "Running qmlLintCheck"

    # intentionally scoped to the default QML prefix, as things in $out/share etc
    # can be used in random weird contexts and will cause spurious errors
    if [ -d "$out/$qtQmlPrefix" ]; then
      find "$out/$qtQmlPrefix" -name '*.qml' | while IFS= read -r i; do
          if [ -n "$(doQmlLint "$i" --json - | @jq@ '.files[] | .warnings[] | select(.id == "import") | select(.message | startswith("Failed to import"))')" ]; then
              echo "qmllint failed for file $i:"

              doQmlLint "$i"
              exit 1
          fi
      done
    fi
}

if [ -z "${dontQmlLint-}" ]; then
    postInstallCheckHooks+=('qmlLintCheck')
fi
