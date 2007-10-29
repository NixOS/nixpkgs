args: with args; with stringsWithDeps; with lib;
rec
{
	inherit writeScript; 

	forceShare = if args ? forceShare then args.forceShare else ["man" "doc" "info"];

	archiveType = s: 
		(if hasSuffixHack ".tar" s then "tar"
		else if (hasSuffixHack ".tar.gz" s) || (hasSuffixHack ".tgz" s) then "tgz" 
		else if (hasSuffixHack ".tar.bz2" s) || (hasSuffixHack ".tbz2" s) then "tbz2"
		else (abort "unknown archive type : ${s}"));

	minInit = noDepEntry ("
		set -e
		NIX_GCC=${stdenv.gcc}
		export SHELL=${stdenv.shell}
		# Set up the initial path.
		PATH=
		for i in \$NIX_GCC ${toString stdenv.initialPath}; do
		    PATH=\$PATH\${PATH:+:}\$i/bin
		done
	" + (if ((stdenv ? preHook) && (stdenv.preHook != null) && 
			((toString stdenv.preHook) != "")) then 
		"
		param1=${stdenv.param1}
		param2=${stdenv.param2}
		param3=${stdenv.param3}
		param4=${stdenv.param4}
		param5=${stdenv.param5}
		source ${stdenv.preHook}

		export TZ=UTC

		prefix=${if args ? prefix then (toString args.prefix) else "\$out"}
		"
	else ""));

	addInputs = FullDepEntry ("
		# Recursively find all build inputs.
		findInputs()
		{
		    local pkg=\$1

		    case \$pkgs in
			*\\ \$pkg\\ *)
			    return 0
			    ;;
		    esac
		    
		    pkgs=\"\$pkgs \$pkg \"

			echo \$pkg
		    if test -f \$pkg/nix-support/setup-hook; then
			source \$pkg/nix-support/setup-hook
			cat \$pkg/nix-support/setup-hook
			echo $PATH;
		    fi
		    
		    if test -f \$pkg/nix-support/propagated-build-inputs; then
			for i in \$(cat \$pkg/nix-support/propagated-build-inputs); do
			    findInputs \$i
			done
		    fi
		}

		pkgs=\"\"
		for i in \$NIX_GCC ${toString buildInputs} ${toString 
		(if (args ? propagatedBuildInputs) then 
		args.propagatedBuildInputs else "")}; do
		    findInputs \$i
		done


		# Set the relevant environment variables to point to the build inputs
		# found above.
		addToEnv()
		{
		    local pkg=\$1
		"+
		(if !((args ? ignoreFailedInputs) && (args.ignoreFailedInputs == 1)) then "
		    if [ -e \$1/nix-support/failed ]; then
			echo \"failed input \$1\" >&2
			fail
		    fi
		" else "")
		+"
		    if test -d \$1/bin; then
			export _PATH=\$_PATH\${_PATH:+:}\$1/bin
		    fi

		    for i in \"\${envHooks[@]}\"; do
			\$i \$pkg
		    done
		}

		for i in \$pkgs; do
		    addToEnv \$i
		done


		# Add the output as an rpath.
		if test \"\$NIX_NO_SELF_RPATH\" != \"1\"; then
		    export NIX_LDFLAGS=\"-rpath \$out/lib \$NIX_LDFLAGS\"
		fi

		PATH=\$_PATH\${_PATH:+:}\$PATH
	") [minInit];
	
	defEnsureDir = FullDepEntry ("
		# Ensure that the given directories exists.
		ensureDir() {
		    local dir
		    for dir in \"\$@\"; do
			if ! test -x \"\$dir\"; then mkdir -p \"\$dir\"; fi
		    done
		}
	") [minInit];

	toSrcDir = s : FullDepEntry (if (archiveType s) == "tar" then "
			tar xvf ${s}
			cd \"\$(tar tf ${s} | head -1 | sed -e 's@/.*@@' )\"
	" else if (archiveType s) == "tgz" then "
			tar xvzf ${s}
			cd \"\$(tar tzf ${s} | head -1 | sed -e 's@/.*@@' )\"
	" else if (archiveType s) == "tbz2" then "
			tar xvjf ${s}
			cd \"\$(tar tjf ${s} | head -1 | sed -e 's@/.*@@' )\"
	" else (abort "unknown archive type : ${s}")) [minInit];

	doConfigure = FullDepEntry ("
		./configure --prefix=\"\$prefix\" ${toString (getAttr ["configureFlags"] "" args)}
	") [minInit addInputs doUnpack];

	doMake = FullDepEntry ("	
		make ${toString (getAttr ["makeFlags"] "" args)}
	") [minInit addInputs doUnpack];

	doUnpack = toSrcDir (toString src);

	doMakeInstall = FullDepEntry ("
		make ${toString (getAttr ["makeFlags"] "" args)} "+
			"${toString (getAttr ["installFlags"] "" args)} install") [doMake];

	doForceShare = FullDepEntry (" 
		ensureDir \$prefix/share
		for d in ${toString forceShare}; do
			if [ -d \$prefix/\$d -a ! -d \$prefix/share/\$d ]; then
				mv -v \$prefix/\$d \$prefix/share
				ln -sv share/\$d \$prefix
			fi;
		done;
	") [minInit defEnsureDir];

	doDump = n: noDepEntry "echo Dump number ${n}; set";

}
