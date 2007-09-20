addCMakeParamsInclude()
{
	if [ -d $1/include ]; then
		export CMAKE_INCLUDE_PATH="${CMAKE_INCLUDE_PATH}${CMAKE_INCLUDE_PATH:+:}$1/include"
	fi
}

addCMakeParamsLibs()
{
	if [ -d $1/lib ]; then
		export CMAKE_LIBRARY_PATH="${CMAKE_LIBRARY_PATH}${CMAKE_LIBRARY_PATH:+:}$1/lib"
	fi
}

fixCmakeFiles()
{
	local replaceArgs;
	echo "Fixing cmake files"
	replaceArgs="-e -f -L -T /usr /FOO"
   	replaceArgs="${replaceArgs}	-a NO_DEFAULT_PATH \"\" -a NO_SYSTEM_PATH \"\""
	find $1 -type f -name "*.cmake" | xargs replace ${replaceArgs}
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

envHooks=(${envHooks[@]} addCMakeParamsInclude addCMakeParamsLibs)
