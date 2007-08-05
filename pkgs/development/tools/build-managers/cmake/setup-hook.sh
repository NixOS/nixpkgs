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

fixCmake()
{
	echo "fixing Cmake file $i"
	sed -e 's@/usr@/FOO@g' -e 's@ /\(bin\|sbin\|lib\)@ /FOO@g' -i $i
}

fixCmakeFiles()
{
	for i in $(find $1 -type f -name "*.cmake"); do
		fixCmake $i;
	done;
}

cmakePostUnpack()
{
	sourceRoot=$sourceRoot/build
	mkdir -v $sourceRoot
	echo source root reset to $sourceRoot

	if [ -z "$dontFixCmake" ]; then
		fixCmakeFiles .
	fi
}

cmakeTweaks()
{
	postUnpack="cmakePostUnpack${postUnpack:+; }${postUnpack}"
	
	if [ -z "$configureScript" ]; then
		dontAddPrefix=1
		configureScript="cmake .."
		configureFlags="-DCMAKE_INSTALL_PREFIX=$out $configureFlags"
	fi
}

if [ -z "$noCmakeTewaks" ]; then
	cmakeTweaks
fi;

envHooks=(${envHooks[@]} addCMakeParamsInclude addCMakeParamsLibs)
