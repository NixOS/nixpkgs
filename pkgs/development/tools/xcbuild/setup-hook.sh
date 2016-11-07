xcbuildPhase() {
    runHook preConfigure

    echo "running xcodebuild"

    xcodebuild

    runHook postConfigure
}

if [ -z "$dontUseXcbuild" -a -z "$configurePhase" ]; then
    configurePhase=xcbuildPhase
fi

# if [ -d "*.xcodeproj" ]; then
#     buildPhase=xcbuildPhase
# fi
