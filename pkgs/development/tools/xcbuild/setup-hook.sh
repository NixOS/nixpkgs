xcbuildBuildPhase() {
    export DSTROOT=$out

    runHook preBuild

    echo "running xcodebuild"

    xcodebuild OTHER_CFLAGS="$NIX_CFLAGS_COMPILE" OTHER_LDFLAGS="$NIX_LDFLAGS" build

    runHook postBuild
}

xcbuildInstallPhase () {
    runHook preInstall

    # not implemented
    # xcodebuild install

    runHook postInstall
}

if [ -z "$dontUseXcbuild" ]; then
    buildPhase=xcbuildBuildPhase
    installPhase=xcbuildInstallPhase
fi

# if [ -d "*.xcodeproj" ]; then
#     buildPhase=xcbuildPhase
# fi
