addCMakeParamsInclude()
{
    addToSearchPath CMAKE_INCLUDE_PATH /include "" $1
}

addCMakeParamsLibs()
{
    addToSearchPath CMAKE_LIBRARY_PATH /lib "" $1
}

addCMakeModulePath()
{
    addToSearchPath CMAKE_MODULE_PATH /share/cmake-2.4/Modules "" $1
}

fixCmakeFiles()
{
    local replaceArgs;
    echo "Fixing cmake files"
    replaceArgs="-e -f -L -T /usr /FOO"
    replaceArgs="${replaceArgs}     -a NO_DEFAULT_PATH \"\" -a NO_SYSTEM_PATH \"\""
    find $1 -type f -name "*.cmake" | xargs replace-literal ${replaceArgs}
}

cmakePostUnpack()
{
    sourceRoot=$sourceRoot/build
    mkdir -v $sourceRoot
    echo source root reset to $sourceRoot

    if [ -z "$dontFixCmake" ]; then
        fixCmakeFiles .
    fi

    if [ -z "$configureScript" ]; then
        configureScript="cmake .."
    fi
    if [ -z "$dontAddPrefix" ]; then
        dontAddPrefix=1
        configureFlags="-DCMAKE_INSTALL_PREFIX=$out $configureFlags"
    fi
}


if [ -z "$noCmakeTewaks" ]; then
    postUnpack="cmakePostUnpack${postUnpack:+; }${postUnpack}"
fi;

envHooks=(${envHooks[@]} addCMakeParamsInclude addCMakeParamsLibs addCMakeModulePath)
