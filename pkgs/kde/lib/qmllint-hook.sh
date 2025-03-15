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

    find "$out" -name '*.qml' | while IFS= read -r i; do
        # qmllint has no "disable all lints" option, so disable them one by one
        if [ -n "$(doQmlLint "$i" --json - | @jq@ '.files[] | .warnings[] | select(.id == "import")')" ]; then
            echo "qmllint failed for file $i:"

            doQmlLint "$i"
            exit 1
        fi
    done
}

if [ -z "${dontQmlLint-}" ]; then
    postInstallHooks+=('qmlLintCheck')
fi
