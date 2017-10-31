xcbuildBuildPhase() {
    export DSTROOT=$out

    runHook preBuild

    echo "running xcodebuild"

    xcodebuild OTHER_CFLAGS="$NIX_CFLAGS_COMPILE" OTHER_CPLUSPLUSFLAGS="$NIX_CFLAGS_COMPILE" OTHER_LDFLAGS="$NIX_LDFLAGS" build

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
    if [ -z "$installPhase" ]; then
        installPhase=xcbuildInstallPhase
    fi
fi

# if [ -d "*.xcodeproj" ]; then
#     buildPhase=xcbuildPhase
# fi
