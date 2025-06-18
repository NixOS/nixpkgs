# Verify that the Xcode project has not changed unexpectedly. This is only useful for source releases that are
# being built with other build systems (e.g., Meson) instead of xcbuild.

verifyXcodeProjectHash() {
    printHashInstructions() {
        echo '1. Set xcodeHash to an empty string: `xcodeHash = "";`'
        echo '2. Build the derivation and wait for it to fail with a hash mismatch'
        echo '3. Copy the "got: sha256-..." value back into the xcodeHash field'
        echo '   You should have: xcodeHash = "sha256-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX=";'
    }

    if [ -z "${xcodeHash-}" ]; then
        echo "error: xcodeHash missing"
        echo
        echo "To fix the issue:"
        printHashInstructions
        exit 1
    fi

    if [ -z "${xcodeProject-}" ]; then
        echo "error: xcodeProject missing"
        echo
        echo "To fix the issue: Set xcodeProject to the name of the project"
        exit 1
    fi

    local xcodeHashArr
    readarray -t -d - xcodeHashArr < <(printf "$xcodeHash")

    local hashType=${xcodeHashArr[0]}
    local expectedHash=${xcodeHashArr[1]}

    if [ -z "$hashType" ] || [ -z "$expectedHash" ]; then
        echo "error: xcodeHash is in invalid format"
        echo
        echo "To fix the issue:"
        printHashInstructions
        exit 1
    fi

    local hash
    hash=$(openssl "$hashType" -binary "$sourceRoot/$xcodeProject/project.pbxproj" | base64)

    if [ "$hash" != "$expectedHash" ]; then
        echo "error: hash mismatch in $xcodeProject/project.pbxproj"
        echo "        specified: $xcodeHash"
        echo "           got:    $hashType-$hash"
        echo
        echo 'Upstream Xcode project has changed. Update `meson.build` with any changes, then update `xcodeHash`.'
        printHashInstructions
        exit 1
    fi
}

postUnpackHooks+=(verifyXcodeProjectHash)
