xcbuildBuildPhase() {
    export DSTROOT=$out

    runHook preBuild

    echo "running xcodebuild"

    xcodebuild SYMROOT=$PWD/Products OBJROOT=$PWD/Intermediates $xcbuildFlags build

    runHook postBuild
}

xcbuildInstallPhase () {
    runHook preInstall

    # not implemented
    # xcodebuild install

    runHook postInstall
}

buildPhase=xcbuildBuildPhase
if [ -z "${installPhase-}" ]; then
    installPhase=xcbuildInstallPhase
fi

# if [ -d "*.xcodeproj" ]; then
#     buildPhase=xcbuildPhase
# fi
