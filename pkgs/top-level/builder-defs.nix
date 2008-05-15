args: with args; with stringsWithDeps; with lib;
(rec
{
	inherit writeScript; 

	src = getAttr ["src"] "" args;

	addSbinPath = getAttr ["addSbinPath"] false args;

	forceShare = if args ? forceShare then args.forceShare else ["man" "doc" "info"];

	archiveType = s: 
		(if hasSuffixHack ".tar" s then "tar"
		else if (hasSuffixHack ".tar.gz" s) || (hasSuffixHack ".tgz" s) then "tgz" 
		else if (hasSuffixHack ".tar.bz2" s) || (hasSuffixHack ".tbz2" s) then "tbz2"
		else if (hasSuffixHack ".zip" s) || (hasSuffixHack ".ZIP" s) then "zip"
		else if (hasSuffixHack "-cvs-export" s) then "cvs-dir"
		else if (hasSuffixHack ".nar.bz2" s) then "narbz2"

		# Mostly for manually specified directories..
		else if (hasSuffixHack "/" s) then "dir"

		# Last block - for single files!! It should be always after .tar.*
		else if (hasSuffixHack ".bz2" s) then "plain-bz2"

		else (abort "unknown archive type : ${s}"));

	defAddToSearchPath = FullDepEntry ("
		addToSearchPathWithCustomDelimiter() {
			local delimiter=\$1
			local varName=\$2
			local needDir=\$3
			local addDir=\${4:-\$needDir}
			local prefix=\$5
			if [ -d \$prefix\$needDir ]; then
				if [ -z \${!varName} ]; then
					eval export \${varName}=\${prefix}\$addDir
				else
					eval export \${varName}=\${!varName}\${delimiter}\${prefix}\$addDir
				fi
			fi
		}

		addToSearchPath()
		{
			addToSearchPathWithCustomDelimiter \"\${PATH_DELIMITER}\" \"\$@\"
		}
	") ["defNest"];

	defNest = noDepEntry ("
		nestingLevel=0

		startNest() {
			nestingLevel=\$((\$nestingLevel + 1))
				echo -en \"\\e[\$1p\"
		}

		stopNest() {
			nestingLevel=\$((\$nestingLevel - 1))
				echo -en \"\\e[q\"
		}

		header() {
			startNest \"\$2\"
				echo \"\$1\"
		}

		# Make sure that even when we exit abnormally, the original nesting
		# level is properly restored.
		closeNest() {
			while test \$nestingLevel -gt 0; do
				stopNest
					done
		}

		trap \"closeNest\" EXIT
	");

	minInit = FullDepEntry ("
		set -e
		NIX_GCC=${stdenv.gcc}
		export SHELL=${stdenv.shell}
		PATH_DELIMITER=':'
	" + (if ((stdenv ? preHook) && (stdenv.preHook != null) && 
			((toString stdenv.preHook) != "")) then 
		"
		param1=${stdenv.param1}
		param2=${stdenv.param2}
		param3=${stdenv.param3}
		param4=${stdenv.param4}
		param5=${stdenv.param5}
		source ${stdenv.preHook}
	" + 	
		"
		# Set up the initial path.
		PATH=
		for i in \$NIX_GCC ${toString stdenv.initialPath}; do
		    PATH=\$PATH\${PATH:+\"\${PATH_DELIMITER}\"}\$i/bin
		done

		export TZ=UTC

		prefix=${if args ? prefix then (toString args.prefix) else "\$out"}

		"
	else "")) ["defNest" "defAddToSearchPath"];
		
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
		    fi
		}

		pkgs=\"\"
		for i in \$NIX_GCC ${toString buildInputs}; do
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
		+(if addSbinPath then "
		    if test -d \$1/sbin; then
			export _PATH=\$_PATH\${_PATH:+\"\${PATH_DELIMITER}\"}\$1/sbin
		    fi
		" else "")
		+"
		    if test -d \$1/bin; then
			export _PATH=\$_PATH\${_PATH:+\"\${PATH_DELIMITER}\"}\$1/bin
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

		PATH=\$_PATH\${_PATH:+\"\${PATH_DELIMITER}\"}\$PATH
	") ["minInit"];
	
	defEnsureDir = FullDepEntry ("
		# Ensure that the given directories exists.
		ensureDir() {
		    local dir
		    for dir in \"\$@\"; do
			if ! test -x \"\$dir\"; then mkdir -p \"\$dir\"; fi
		    done
		}
	") ["minInit"];

	toSrcDir = s : FullDepEntry ((if (archiveType s) == "tar" then "
		tar xvf '${s}'
		cd \"\$(tar tf '${s}' | head -1 | sed -e 's@/.*@@' )\"
	" else if (archiveType s) == "tgz" then "
		tar xvzf '${s}'
		cd \"\$(tar tzf '${s}' | head -1 | sed -e 's@/.*@@' )\"
	" else if (archiveType s) == "tbz2" then "
		tar xvjf '${s}'
		cd \"\$(tar tjf '${s}' | head -1 | sed -e 's@/.*@@' )\"
	" else if (archiveType s) == "zip" then "
		unzip '${s}'
		cd \"$( unzip -lqq '${s}' | tail -1 | 
			sed -e 's@^\\(\\s\\+[-0-9:]\\+\\)\\{3,3\\}\\s\\+\\([^/]\\+\\)/.*@\\2@' )\"
	" else if (archiveType s) == "cvs-dir" then "
		cp -r '${s}' .
		cd \$(basename ${s})
		chmod u+rwX -R .
	" else if (archiveType s) == "dir" then "
		cp -r '${s}' .
		cd \$(basename ${s})
		chmod u+rwX -R .
	" else if (archiveType s) == "narbz2" then "
		bzip2 <${s} | nix-store --restore \$PWD/\$(basename ${s} .nar.bz2)
		cd \$(basename ${s} .nar.bz2)
	" else if (archiveType s) == "plain-bz2" then "
		mkdir \$PWD/\$(basename ${s} .bz2)
		NAME=\$(basename ${s} .bz2)
		bzip2 -d <${s} > \$PWD/\$(basename ${s} .bz2)/\${NAME#*-}
		cd \$(basename ${s} .bz2)
	" else (abort "unknown archive type : ${s}"))+
                # goSrcDir is typically something like "cd mysubdir" .. but can be anything else 
		(if args ? goSrcDir then args.goSrcDir else "")
	) ["minInit"];

	configureCommand = getAttr ["configureCommand"] "./configure" args;

	doConfigure = FullDepEntry ("
		${configureCommand} --prefix=\"\$prefix\" ${toString configureFlags}
	") ["minInit" "addInputs" "doUnpack"];

	doAutotools = FullDepEntry ("
		mkdir -p config
		libtoolize --copy --force
		aclocal --force
		#Some packages do not need this
		autoheader || true; 
		automake --add-missing --copy
		autoconf
	")["minInit" "addInputs" "doUnpack"];

	doMake = FullDepEntry ("	
		make ${toString makeFlags}
	") ["minInit" "addInputs" "doUnpack"];

	doUnpack = toSrcDir (toString src);

	installPythonPackage = FullDepEntry ("
		python setup.py install --prefix=\"\$prefix\" 
		") ["minInit" "addInputs" "doUnpack"];

	doMakeInstall = FullDepEntry ("
		make ${toString (getAttr ["makeFlags"] "" args)} "+
			"${toString (getAttr ["installFlags"] "" args)} install") ["doMake"];

	doForceShare = FullDepEntry (" 
		ensureDir \"\$prefix/share\"
		for d in ${toString forceShare}; do
			if [ -d \"\$prefix/\$d\" -a ! -d \"\$prefix/share/\$d\" ]; then
				mv -v \"\$prefix/\$d\" \"\$prefix/share\"
				ln -sv share/\$d \"\$prefix\"
			fi;
		done;
	") ["minInit" "defEnsureDir"];

	doDump = n: noDepEntry "echo Dump number ${n}; set";

	patchFlags = if args ? patchFlags then args.patchFlags else "-p1";

	patches = getAttr ["patches"] [] args;

	toPatchCommand = s: "cat ${toString s} | patch ${toString patchFlags}";

	doPatch = FullDepEntry (concatStringsSep ";"
		(map toPatchCommand patches)
	) ["minInit" "doUnpack"];

	envAdderInner = s: x: if x==null then s else y: 
		a: envAdderInner (s+"echo export ${x}='\"'\"\$${x}:${y}\";'\"'\n") a;

	envAdder = envAdderInner "";

	envAdderList = l:  if l==[] then "" else 
	"echo export ${__head l}='\"'\"\\\$${__head l}:${__head (__tail l)}\"'\"';\n" +
		envAdderList (__tail (__tail l));

	wrapEnv = cmd: env: "
		mv \"${cmd}\" \"${cmd}-orig\";
		touch \"${cmd}\";
		chmod a+rx \"${cmd}\";
		(${envAdderList env}
		echo '\"'\"${cmd}-orig\"'\"' '\"'\\\$@'\"' \n)  > \"${cmd}\"";

	doWrap = cmd: FullDepEntry (wrapEnv cmd (getAttr ["wrappedEnv"] [] args)) ["minInit"];

	doPropagate = FullDepEntry ("
		ensureDir \$out/nix-support
		echo '${toString (getAttr ["propagatedBuildInputs"] [] args)}' >\$out/nix-support/propagated-build-inputs
	") ["minInit" "defEnsureDir"];

	/*debug = x:(__trace x x);
	debugX = x:(__trace (__toXML x) x);*/

	replaceScriptVar = file: name: value: ("sed -e 's`^${name}=.*`${name}='\\''${value}'\\''`' -i ${file}");
	replaceInScript = file: l: (concatStringsSep "\n" ((pairMap (replaceScriptVar file) l)));
	replaceScripts = l:(concatStringsSep "\n" (pairMap replaceInScript l));
	doReplaceScripts = FullDepEntry (replaceScripts (getAttr ["shellReplacements"] [] args)) [minInit];
	makeNest = x:(if x==defNest.text then x else "startNest\n" + x + "\nstopNest\n");
        textClosure = a : steps : textClosureMapOveridable makeNest a (["defNest"] ++ steps);

	inherit noDepEntry FullDepEntry PackEntry;

	defList = (getAttr ["defList"] [] args);
	getVal = getValue args defList;
	check = checkFlag args;
	reqsList = getAttr ["reqsList"] [] args;
	buildInputsNames = filter (x: (null != getVal x))
		(uniqList {inputList = 
		(concatLists (map 
		(x:(if (x==[]) then [] else builtins.tail x)) 
		reqsList));});
	configFlags = getAttr ["configFlags"] [] args;
	buildFlags = getAttr ["buildFlags"] [] args;
	nameSuffixes = getAttr ["nameSuffixes"] [] args;
	autoBuildInputs = assert (checkReqs args defList reqsList);
		filter (x: x!=null) (map getVal buildInputsNames);
	autoConfigureFlags = condConcat "" configFlags check;
	autoMakeFlags = condConcat "" buildFlags check;
	useConfig = getAttr ["useConfig"] false args;
	buildInputs = 
		lib.closePropagation ((if useConfig then 
			autoBuildInputs else 
			getAttr ["buildInputs"] [] args)++
			(getAttr ["propagatedBuildInputs"] [] args));
	configureFlags = if useConfig then autoConfigureFlags else 
	    getAttr ["configureFlags"] "" args;
	makeFlags = if useConfig then autoMakeFlags else getAttr ["makeFlags"] "" args;

	inherit lib;

	surroundWithCommands = x : before : after : {deps=x.deps; text = before + "\n" +
		x.text + "\n" + after ;};


        # some haskell stuff  - untested!
        # --------------------------------------------------------
        # creates a setup hook
        # adding the package database 
        # nix-support/package.conf to GHC_PACKAGE_PATH
        # if not already contained
        # using nix-support because user does'nt want to have it in it's
        # nix-profile I think?
        defSetupHookRegisteringPackageDatabase = noDepEntry (
          "\nsetupHookRegisteringPackageDatabase(){" +
          "\n  ensureDir $out/nix-support;" +
          "\n  if test -n \"$1\"; then" +
          "\n    local pkgdb=$1" +
          "\n  else" +
          "\n    local pkgdb=$out/nix-support/package.conf" +
          "\n  fi" +
          "\n  cat >> $out/nix-support/setup-hook << EOF" +
          "\n    " +
          "\n    echo \$GHC_PACKAGE_PATH | grep -l $pkgdb &> /dev/null || \" "+
          "\n      export GHC_PACKAGE_PATH=\$GHC_PACKAGE_PATH\${GHC_PACKAGE_PATH:+\"\${PATH_DELIMITER}\"}$pkgdb;" +
          "\nEOF" +
          "\n}");

        # Either rungghc or compile setup.hs 
        # / which one is better ? runghc had some trouble with ghc-6.6.1
        defCabalSetupCmd = noDepEntry "
          CABAL_SETUP=\"runghc setup.hs\"
        ";
        
        # create an empty package database in which the new library can be registered. 
        defCreateEmptyPackageDatabaseAndSetupHook = FullDepEntry "
          createEmptyPackageDatabaseAndSetupHook(){
            ensureDir $out/nix-support;
            PACKAGE_DB=$out/nix-support/package.conf;
            echo '[]' > \"$PACKAGE_DB\";
            setupHookRegisteringPackageDatabase
        }" ["defSetupHookRegisteringPackageDatabase" "defEnsureDir"];

        # Cabal does only support --user ($HOME/.ghc/** ) and --global (/nix/store/*-ghc/lib/...) 
        # But we need kind of --custom=my-package-db
        # by accident cabal does support using multiple databases passed by GHC_PACKAGE_PATH
        # 
        # Options:
        # 1) create a local package db containing all dependencies
        # 2) create a single db file for each package merging them using GHC_PACKAGE_PATH=db1:db2 
        # (no trailing : which would mean add global and user db)
        # I prefer 2) (Marc Weber) so the most convinient way is
        # using ./setup copy to install
        # and   ./setup register --gen-script to install to our local database 
        # after replacing /usr/lib etc with our pure $out path
        cabalBuild = FullDepEntry 
          " createEmptyPackageDatabaseAndSetupHook
          ghc --make setup.hs -o setup
          \$CABAL_SETUP configure
          \$CABAL_SETUP build
          \$CABAL_SETUP copy --dest-dir=\$out
          \$CABAL_SETUP register --gen-script
          sed -e 's=/usr/local/lib=\$out=g' \\
              -i register.sh
          GHC_PACKAGE_PATH=\$PACKAGE_DB ./register.sh
        " ["defCreateEmptyPackageDatabaseAndSetupHook" "defCabalSetupCmd"];

	phaseNames = args.phaseNames ++ 
	  ["doForceShare" "doPropagate"];
        
	extraDerivationAttrs = lib.getAttr ["extraDerivationAttrs"] {} args;

	builderDefsPackage = bd: func: args: (
	let localDefs = bd (func ((bd null) // args)) args null; in

	stdenv.mkDerivation ((rec {
	  inherit (localDefs) name;
	  builder = writeScript (name + "-builder")
	    (textClosure localDefs localDefs.phaseNames);
	  meta = localDefs.meta // {inherit src;};
	}) // (if localDefs ? propagatedBuildInputs then {
	  inherit (localDefs) propagatedBuildInputs;
	} else {}) // extraDerivationAttrs)
	);

   generateFontsFromSFD = noDepEntry(''
   	for i in *.sfd; do
		${args.fontforge}/bin/fontforge -c \
			'Open($1);
			${optionalString (args ? extraFontForgeCommands) args.extraFontForgeCommands
			}Reencode("unicode");
			 ${optionalString (getAttr ["createTTF"] true args) ''Generate($1:r + ".ttf");''}
			 ${optionalString (getAttr ["createOTF"] true args) ''Generate($1:r + ".otf");''}
			 Reencode("TeX-Base-Encoding");
			 ${optionalString (getAttr ["createAFM"] true args) ''Generate($1:r + ".afm");''}
			 ${optionalString (getAttr ["createPFM"] true args) ''Generate($1:r + ".pfm");''}
			 ${optionalString (getAttr ["createPFB"] true args) ''Generate($1:r + ".pfb");''}
			 ${optionalString (getAttr ["createMAP"] true args) ''Generate($1:r + ".map");''}
			 ${optionalString (getAttr ["createENC"] true args) ''Generate($1:r + ".enc");''}
			' $i; 
	done
   '');

   installFonts = FullDepEntry (''
   	ensureDir $out/share/fonts/truetype/public/${args.name}
   	ensureDir $out/share/fonts/opentype/public/${args.name}
   	ensureDir $out/share/fonts/type1/public/${args.name}
   	ensureDir $out/share/texmf/fonts/enc/${args.name}
   	ensureDir $out/share/texmf/fonts/map/${args.name}

	cp *.ttf $out/share/fonts/truetype/public/${args.name} || echo No TrueType fonts
	cp *.otf $out/share/fonts/opentype/public/${args.name} || echo No OpenType fonts
   	cp *.{pfm,afm,pfb} $out/share/fonts/type1/public/${args.name} || echo No Type1 Fonts
   	cp *.enc $out/share/texmf/fonts/enc/${args.name} || echo No fontenc data
   	cp *.map $out/share/texmf/fonts/map/${args.name} || echo No fontmap data
   '') ["minInit" "defEnsureDir"];

}) // args
