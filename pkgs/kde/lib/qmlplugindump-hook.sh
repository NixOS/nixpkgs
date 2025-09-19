# shellcheck shell=bash
generateQmlStubs() {
    echo "Generating QML type stubs for $1 $2..."

    if ! [ -v qtQmlPrefix ]; then
        echo "qmlLintHook: qtQmlPrefix is unset. hint: add qt6.qtbase to buildInputs"
        exit 1
    fi

    local qmlRoot="$out/${qtQmlPrefix:?}"
    local outdir="$qmlRoot/${1//./\//}"
    mkdir -p "$outdir"

    QML2_IMPORT_PATH="$qmlRoot" @qmlplugindump@ "$1" "$2" > "$outdir/_nixos_generated.qmltypes"
    echo "typeinfo _nixos_generated.qmltypes" >> "$outdir/qmldir"
}
