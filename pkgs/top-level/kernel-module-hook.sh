kernelModuleBuildPhase() {
    runHook preBuild
    local buildCores=1

    if [ "${enableParallelBuilding-1}" ]; then
        buildCores="$NIX_BUILD_CORES"
    fi

    local flagsArray=(
        "-j$buildCores"
        @kernelModuleMakeFlags@
        "KERNELRELEASE=@modDirVersion@"
        "-C"
        "@kernel_dev@/lib/modules/@modDirVersion@/build"
    )
    concatTo flagsArray makeFlags makeFlagsArray

    local kbuildDirsArray=()
    concatTo kbuildDirsArray kbuildDirectories kbuildDirectoriesArray
    local kbuildDirsArgs=()
    if [ ${#kbuildDirsArray[@]} -eq 0 ]; then
        kbuildDirsArgs=("M=$(pwd)")
    else
        for dir in "${kbuildDirsArray[@]}"; do
            kbuildDirsArgs+=("M=$(pwd)/$dir")
        done
    fi

    for dirArg in "${kbuildDirsArgs[@]}"; do
        echoCmd 'build flags' "$dirArg" "${flagsArray[@]}"
        make modules "$dirArg" "${flagsArray[@]}"
    done

    runHook postBuild
}

kernelModuleInstallPhase() {
    runHook preInstall
    local buildCores=1

    if [ "${enableParallelInstalling-1}" ]; then
        buildCores="$NIX_BUILD_CORES"
    fi

    local flagsArray=(
        "-j$buildCores"
        @kernelModuleMakeFlags@
        "KERNELRELEASE=@modDirVersion@"
        "INSTALL_MOD_PATH=${!outputLib}"
        "-C"
        "@kernel_dev@/lib/modules/@modDirVersion@/build"
    )
    concatTo flagsArray makeFlags makeFlagsArray installFlags installFlagsArray

    local kbuildDirsArray=()
    concatTo kbuildDirsArray kbuildDirectories kbuildDirectoriesArray
    local kbuildDirsArgs=()
    if [ ${#kbuildDirsArray[@]} -eq 0 ]; then
        kbuildDirsArgs=("M=$(pwd)")
    else
        for dir in "${kbuildDirsArray[@]}"; do
            kbuildDirsArgs+=("M=$(pwd)/$dir")
        done
    fi

    for dirArg in "${kbuildDirsArgs[@]}"; do
        echoCmd 'install flags' "$dirArg" "${flagsArray[@]}"
        make modules_install "$dirArg" "${flagsArray[@]}"
    done

    runHook postInstall
}

if [ -z "${dontUseKernelModuleBuild-}" ] && [ -z "${buildPhase-}" ]; then
    buildPhase=kernelModuleBuildPhase
fi
if [ -z "${dontUseKernelModuleInstall-}" ] && [ -z "${installPhase-}" ]; then
    installPhase=kernelModuleInstallPhase
fi
