# shellcheck disable=SC2154,SC2034
# shellcheck shell=bash

# The installer is a Makeself archive. Extracting it needs its decompressor
# (`zstd` since 530.30.02, `gzip`/`bzip2`/`xz` before that) plus the tools the
# Makeself preamble drives them with.

unpackCmdHooks+=(unpackNvidiaDriver)

unpackNvidiaDriver() {
    # Every installer is a shell script, but not every one is called `.run`:
    # the Vulkan developer driver comes as `vulkan-beta-<version>-linux`.
    if ! head -c 2 "$curSrc" | grep -q '#!'; then
        return 1
    fi

    if sh "$curSrc" -x; then
        # The installer creates a directory named after the package, which
        # `unpackPhase` picks up as the source root on its own.
        return 0
    fi

    echoWarning "unpacking $curSrc by extracting its embedded tarball; the"
    echoWarning "installer's own extraction step failed"

    # The archive also embeds a plain tarball after a `skip=` line.
    skip=$(sed 's/^skip=//; t; d' "$curSrc")
    tail -n +"$skip" "$curSrc" | bsdtar xvf -

    # That tarball unpacks flat into the current directory.
    sourceRoot=.
}