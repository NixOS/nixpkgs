xcbuildPhase() {
    runHook preConfigure

    echo "running xcodebuild"

    xcodebuild OTHER_CFLAGS="$NIX_CFLAGS_COMPILE"

    runHook postConfigure
}

if [ -z "$dontUseXcbuild" -a -z "$configurePhase" ]; then
    configurePhase=xcbuildPhase
fi

# if [ -d "*.xcodeproj" ]; then
#     buildPhase=xcbuildPhase
# fi
