# PaX-mark binaries.
paxmark() {
    local flags="$1"
    shift

    paxctl -c "$@"
    paxctl -zex -${flags} "$@"
}
