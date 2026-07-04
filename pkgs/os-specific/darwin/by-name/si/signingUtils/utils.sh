# Work around for some odd behaviour where we can't codesign a file
# in-place if it has been called before. This happens for example if
# you try to fix-up a binary using strip/install_name_tool, after it
# had been used previous.  The solution is to copy the binary (with
# the corrupted signature from strip/install_name_tool) to some
# location, sign it there and move it back into place.
#
# This does not appear to happen with the codesign tool that ships
# with recent macOS BigSur installs on M1 arm64 machines.  However it
# had also been happening with the tools that shipped with the DTKs.
sign() {
    local tmpdir
    tmpdir=$(mktemp -d)

    # $1 is the file

    cp "$1" "$tmpdir"
    CODESIGN_ALLOCATE=@codesignAllocate@ \
        @sigtool@/bin/codesign -f -s - "$tmpdir/$(basename "$1")"
    mv "$tmpdir/$(basename "$1")" "$1"
    rmdir "$tmpdir"
}

checkRequiresSignature() {
    local file=$1
    local rc=0

    @sigtool@/bin/sigtool --file "$file" check-requires-signature || rc=$?

    if [ "$rc" -eq 0 ] || [ "$rc" -eq 1 ]; then
        return "$rc"
    fi

    echo "Unexpected exit status from sigtool: $rc"
    exit 1
}

signIfRequired() {
    local file=$1
    if checkRequiresSignature "$file"; then
        sign "$file"
    fi
}
