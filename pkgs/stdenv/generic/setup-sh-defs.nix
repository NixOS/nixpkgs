with (import ../../lib/strings-with-deps.nix (import ../../lib/default-unstable.nix)); 

rec {
	setStrictMode = noDepEntry "set -e;";
	setNixGcc = noDepEntry "test -z \$NIX_GCC && NIX_GCC=@gcc@;";
	
	initPath = noDepEntry "# Set up the initial path.
PATH=
for i in \$NIX_GCC @initialPath@; do
    PATH=\$PATH\${PATH:+:}\$i/bin
done

if test \"\$NIX_DEBUG\" = \"1\"; then
    echo \"Initial path: \$PATH\"
fi
";

	execPreHook = FullDepEntry "# Execute the pre-hook.
export SHELL=@shell@
if test -z \"\$shell\"; then
    export shell=@shell@
fi
param1=@param1@
param2=@param2@
param3=@param3@
param4=@param4@
param5=@param5@
if test -n \"@preHook@\"; then
    source @preHook@
fi
" [initPath];

	checkShellEnv = FullDepEntry "# Check that the pre-hook initialised SHELL.
if test -z \"\$SHELL\"; then echo \"SHELL not set\"; exit 1; fi
" [execPreHook];

	gccSetupHook = FullDepEntry "# Hack: run gcc's setup hook.
envHooks=()
if test -f \$NIX_GCC/nix-support/setup-hook; then
    source \$NIX_GCC/nix-support/setup-hook
fi
" [setNixGcc initPath execPreHook];

    
	defEnsureDir = FullDepEntry "# Ensure that the given directories exists.
ensureDir() {
    local dir
    for dir in \"\$@\"; do
        if ! test -x \"\$dir\"; then mkdir -p \"\$dir\"; fi
    done
}
" [initPath];

	defFail = FullDepEntry "# Called when some build action fails.  If \$succeedOnFailure is set,
# create the file `\$out/nix-support/failed' to signal failure, and
# exit normally.  Otherwise, exit with failure.
fail() {
    exitCode=\$?
    if test \"\$succeedOnFailure\" = 1; then
        ensureDir \"\$out/nix-support\"
        touch \"\$out/nix-support/failed\"
        exit 0
    else
        exit \$?
    fi
}
" [initPath];

	runAddInputsHook = FullDepEntry "# Allow the caller to augment buildInputs (it's not always possible to
# do this before the call to setup.sh, since the PATH is empty at that
# point; here we have a basic Unix environment).
eval \"\$addInputsHook\"
" [initPath gccSetupHook defFail];

	defFindInputs = FullDepEntry "# Recursively find all build inputs.
findInputs()
{
    local pkg=\$1

    case \$pkgs in
        *\ \$pkg\ *)
            return 0
            ;;
    esac
    
    pkgs=\"\$pkgs \$pkg \"

    if test -f \$pkg/nix-support/setup-hook; then
        source \$pkg/nix-support/setup-hook
    fi
    
    if test -f \$pkg/nix-support/propagated-build-inputs; then
        for i in \$(cat \$pkg/nix-support/propagated-build-inputs); do
            findInputs \$i
        done
    fi
}
" [initPath];

	getInputs = FullDepEntry "pkgs=\"\"
if test -n \"\$buildinputs\"; then
    buildInputs=\"\$buildinputs\" # compatibility
fi
for i in \$buildInputs \$propagatedBuildInputs; do
    findInputs \$i
done
" [defFindInputs runAddInputsHook];

	defAddToEnv = FullDepEntry "# Set the relevant environment variables to point to the build inputs
# found above.
addToEnv()
{
    local pkg=\$1

    if test \"\$ignoreFailedInputs\" != \"1\" -a -e \$1/nix-support/failed; then
        echo \"failed input \$1\" >&2
        fail
    fi

    if test -d \$1/bin; then
        export _PATH=\$_PATH\${_PATH:+:}\$1/bin
    fi

    for i in \"\${envHooks[@]}\"; do
        \$i \$pkg
    done
}
" [defFail];

	preparePackageEnv = FullDepEntry "for i in \$pkgs; do
    addToEnv \$i
done
" [getInputs defAddToEnv];

	putOutInRpath = FullDepEntry "# Add the output as an rpath.
if test \"\$NIX_NO_SELF_RPATH\" != \"1\"; then
    export NIX_LDFLAGS=\"-rpath \$out/lib \$NIX_LDFLAGS\"
fi
" [initPath];

	setupStripping = FullDepEntry "# Strip debug information by default.
if test -z \"\$NIX_STRIP_DEBUG\"; then
    export NIX_STRIP_DEBUG=1
    export NIX_CFLAGS_STRIP=\"-g0 -Wl,--strip-debug\"
fi
" [initPath];

	checkNixEnv = FullDepEntry "# Do we know where the store is?  This is required for purity checking.
if test -z \"\$NIX_STORE\"; then
    echo \"Error: you have an old version of Nix that does not set the\" \
        \"NIX_STORE variable.  Please upgrade.\" >&2
    exit 1
fi


# We also need to know the root of the build directory for purity checking.
if test -z \"\$NIX_BUILD_TOP\"; then
    echo \"Error: you have an old version of Nix that does not set the\" \
        \"NIX_BUILD_TOP variable.  Please upgrade.\" >&2
    exit 1
fi
" [initPath];

	setTZ = noDepEntry "# Set the TZ (timezone) environment variable, otherwise commands like
# `date' will complain (e.g., `Tue Mar 9 10:01:47 Local time zone must
# be set--see zic manual page 2004').
export TZ=UTC
" ;

	setPrefix = FullDepEntry "# Set the prefix.  This is generally \$out, but it can be overriden,
# for instance if we just want to perform a test build/install to a
# temporary location and write a build report to \$out.
if test -z \"\$prefix\"; then
    prefix=\"\$out\";
fi

if test \"\$useTempPrefix\" = \"1\"; then
    prefix=\"\$NIX_BUILD_TOP/tmp_prefix\";
fi
" [checkNixEnv];

	runPostHook = FullDepEntry "# Execute the post-hook.
if test -n \"@postHook@\"; then
    source @postHook@
fi
" [setTZ setPrefix execPreHook gccSetupHook preparePackageEnv];

	finalSetPath = FullDepEntry "PATH=\$_PATH\${_PATH:+:}\$PATH
if test \"\$NIX_DEBUG\" = \"1\"; then
    echo \"Final path: \$PATH\"
fi
" [runPostHook];

	defSubstitute = FullDepEntry "######################################################################
# Textual substitution functions.


# Some disgusting hackery to escape replacements in Sed substitutions.
# We should really have a tool that replaces literal values by other
# literal values, without any need for escaping.
escapeSed() {
    local s=\"\$1\"
    # The `tr' hack is to escape newlines.  Sed handles newlines very
    # badly, so we just replace newlines with the magic character 0xff
    # (377 octal).  So don't use that character in replacements :-P
    echo -n \"\$1\" | tr '\012' '\377' | sed -e 's^\\^\\\\^g' -e 's^\xff^\\n^g' -e 's/\^/\\^/g' -e 's/&/\\&/g'
}


substitute() {
    local input=\"\$1\"
    local output=\"\$2\"

    local -a params=(\"\$@\")

    local sedScript=\$NIX_BUILD_TOP/.sedargs
    rm -f \$sedScript
    touch \$sedScript

    local n p pattern replacement varName
    
    for ((n = 2; n < \${#params[*]}; n += 1)); do
        p=\${params[\$n]}

        if test \"\$p\" = \"--replace\"; then
            pattern=\"\${params[\$((n + 1))]}\"
            replacement=\"\${params[\$((n + 2))]}\"
            n=\$((n + 2))
        fi

        if test \"\$p\" = \"--subst-var\"; then
            varName=\"\${params[\$((n + 1))]}\"
            pattern=\"@\$varName@\"
            replacement=\"\${!varName}\"
            n=\$((n + 1))
        fi

        if test \"\$p\" = \"--subst-var-by\"; then
            pattern=\"@\${params[\$((n + 1))]}@\"
            replacement=\"\${params[\$((n + 2))]}\"
            n=\$((n + 2))
        fi

        replacement=\"\$(escapeSed \"\$replacement\")\"

        echo \"s^\$pattern^\$replacement^g\" >> \$sedScript
    done

    sed -f \$sedScript < \"\$input\" > \"\$output\".tmp
    if test -x \"\$output\"; then
        chmod +x \"\$output\".tmp
    fi
    mv -f \"\$output\".tmp \"\$output\"
}


substituteInPlace() {
    local fileName=\"\$1\"
    shift
    substitute \"\$fileName\" \"\$fileName\" \"\$@\"
}


substituteAll() {
    local input=\"\$1\"
    local output=\"\$2\"
    
    # Select all environment variables that start with a lowercase character.
    for envVar in \$(env | sed \"s/^[^a-z].*//\" | sed \"s/^\([^=]*\)=.*/\1/\"); do
        if test \"\$NIX_DEBUG\" = \"1\"; then
            echo \"\$envVar -> \${!envVar}\"
        fi
        args=\"\$args --subst-var \$envVar\"
    done

    substitute \"\$input\" \"\$output\" \$args
}  
" [initPath];

	defNest = NoDepEntry "######################################################################
# What follows is the generic builder.


nestingLevel=0

startNest() {
    nestingLevel=\$((\$nestingLevel + 1))
    echo -en \"\e[\$1p\"
}

stopNest() {
    nestingLevel=\$((\$nestingLevel - 1))
    echo -en \"\e[q\"
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
" ;


	defDumpVars = FullDepEntry "# This function is useful for debugging broken Nix builds.  It dumps
# all environment variables to a file `env-vars' in the build
# directory.  If the build fails and the `-K' option is used, you can
# then go to the build directory and source in `env-vars' to reproduce
# the environment used for building.
dumpVars() {
    if test \"\$noDumpEnvVars\" != \"1\"; then
        export > \$NIX_BUILD_TOP/env-vars
    fi
}
" [checkNixEnv];


	defStartStopLog = FullDepEntry  "# Redirect stdout/stderr to a named pipe connected to a `tee' process
# that writes the specified file (and also to our original stdout).
# The original stdout is saved in descriptor 3.
startLog() {
    local logFile=\${logNr}_\$1
    logNr=\$((logNr + 1))
    if test \"\$logPhases\" = 1; then
        ensureDir \$logDir

        exec 3>&1

        if test \"\$dontLogThroughTee\" != 1; then
            # This required named pipes (fifos).
            logFifo=\$NIX_BUILD_TOP/log_fifo
            test -p \$logFifo || mkfifo \$logFifo
            startLogWrite \"\$logDir/\$logFile\" \"\$logFifo\"
            exec > \$logFifo 2>&1
        else
            exec > \$logDir/\$logFile 2>&1
        fi
    fi
}

# Factored into a separate function so that it can be overriden.
startLogWrite() {
    tee \"\$1\" < \"\$2\" &
    logWriterPid=\$!
}

# Restore the original stdout/stderr.
stopLog() {
    if test \"\$logPhases\" = 1; then
        exec >&3 2>&1

        # Wait until the tee process has died.  Otherwise output from
        # different phases may be mixed up.
        if test -n \"\$logWriterPid\"; then
            wait \$logWriterPid
            logWriterPid=
            rm \$logFifo
        fi
    fi
}


" [setLogVars checkNixEnv ];


	setLogVars = FullDepEntry "if test -z \"\$logDir\"; then
    logDir=\$out/log
fi

logNr=0
" [initPath];

	defStripHash = FullDepEntry "# Utility function: return the base name of the given path, with the
# prefix `HASH-' removed, if present.
stripHash() {
    strippedName=\$(basename \$1);
    if echo \"\$strippedName\" | grep -q '^[a-z0-9]\{32\}-'; then
        strippedName=\$(echo \"\$strippedName\" | cut -c34-)
    fi
}
" [initPath];

	defUnpack = FullDepEntry "
unpackFile() {
    local file=\$1
    local cmd

    header \"unpacking source archive \$file\" 3

    case \$file in
        *.tar)
            tar xvf \$file || fail
            ;;
        *.tar.gz | *.tgz | *.tar.Z)
            gunzip < \$file | tar xvf - || fail
            ;;
        *.tar.bz2 | *.tbz2)
            bunzip2 < \$file | tar xvf - || fail
            ;;
        *.zip)
            unzip \$file || fail
            ;;
        *)
            if test -d \"\$file\"; then
                stripHash \$file
                cp -prvd \$file \$strippedName || fail
            else
                if test -n \"\$findUnpacker\"; then
                    \$findUnpacker \$1;
                fi
                if test -z \"\$unpackCmd\"; then
                    echo \"source archive \$file has unknown type\"
                    exit 1
                fi
                eval \"\$unpackCmd\" || fail
            fi
            ;;
    esac

    stopNest
}
" [preparePackageEnv];

	defUnpackW = FullDepEntry "
unpackW() {
    if test -n \"\$unpackPhase\"; then
        eval \"\$unpackPhase\"
        return
    fi

    if test -z \"\$srcs\"; then
        if test -z \"\$src\"; then
            echo 'variable \$src or \$srcs should point to the source'
            exit 1
        fi
        srcs=\"\$src\"
    fi

    # To determine the source directory created by unpacking the
    # source archives, we record the contents of the current
    # directory, then look below which directory got added.  Yeah,
    # it's rather hacky.
    local dirsBefore=\"\"
    for i in *; do
        if test -d \"\$i\"; then
            dirsBefore=\"\$dirsBefore \$i \"
        fi
    done

    # Unpack all source archives.
    for i in \$srcs; do
        unpackFile \$i
    done

    # Find the source directory.
    if test -n \"\$setSourceRoot\"; then
        eval \"\$setSourceRoot\"
    else
        sourceRoot=
        for i in *; do
            if test -d \"\$i\"; then
                case \$dirsBefore in
                    *\ \$i\ *)
                        ;;
                    *)
                        if test -n \"\$sourceRoot\"; then
                            echo \"unpacker produced multiple directories\"
                            exit 1
                        fi
                        sourceRoot=\$i
                        ;;
                esac
            fi
        done
    fi

    if test -z \"\$sourceRoot\"; then
        echo \"unpacker appears to have produced no directories\"
        exit 1
    fi

    echo \"source root is \$sourceRoot\"

    # By default, add write permission to the sources.  This is often
    # necessary when sources have been copied from other store
    # locations.
    if test \"dontMakeSourcesWritable\" != 1; then
        chmod -R +w \$sourceRoot
    fi

    eval \"\$postUnpack\"
}
" [defUnpack];



defUnpackPhase = FullDepEntry "
unpackPhase() {
    sourceRoot=. # don't change to user dir homeless shelter if custom unpackSource does'nt set sourceRoot
    header \"unpacking sources\"
    startLog \"unpack\"
    unpackW
    stopLog
    stopNest
    cd \$sourceRoot
}
" [unpackW];


	defPatchW = FullDepEntry "
patchW() {
    if test -n \"\$patchPhase\"; then
        eval \"\$patchPhase\"
        return
    fi

    if test -z \"\$patchFlags\"; then
        patchFlags=\"-p1\"
    fi

    for i in \$patches; do
        header \"applying patch \$i\" 3
        local uncompress=cat
        case \$i in
            *.gz)
                uncompress=gunzip
                ;;
            *.bz2)
                uncompress=bunzip2
                ;;
        esac
        \$uncompress < \$i | patch \$patchFlags || fail
        stopNest
    done
}
" [getInputs]

	defPatchPhase = FullDepEntry "
patchPhase() {
    if test -z \"\$patchPhase\" -a -z \"\$patches\"; then return; fi
    header \"patching sources\"
    startLog \"patch\"
    patchW
    stopLog
    stopNest
}
" [defPatchW];

	defFixLibTool = FullDepEntry "fixLibtool() {
    sed 's^eval sys_lib_.*search_path=.*^^' < \$1 > \$1.tmp
    mv \$1.tmp \$1
}
" [initPath];

	defConfigureW = FullDepEntry "
configureW() {
    if test -n \"\$configurePhase\"; then
        eval \"\$configurePhase\"
        return
    fi

    eval \"\$preConfigure\"

    if test -z \"\$configureScript\"; then
        configureScript=./configure
        if ! test -x \$configureScript; then
            echo \"no configure script, doing nothing\"
            return
        fi
    fi

    if test -z \"\$dontFixLibtool\"; then
        for i in \$(find . -name \"ltmain.sh\"); do
            echo \"fixing libtool script \$i\"
            fixLibtool \$i
        done
    fi

    if test -z \"\$dontAddPrefix\"; then
        configureFlags=\"--prefix=\$prefix \$configureFlags\"
    fi

    echo \"configure flags: \$configureFlags \${configureFlagsArray[@]}\"
    \$configureScript \$configureFlags\"\${configureFlagsArray[@]}\" || fail

    eval \"\$postConfigure\"
}
" [initPath];


	defConfigurePhase = FullDepEntry "
configurePhase() {
    header \"configuring\"
    startLog \"configure\"
    configureW
    stopLog
    stopNest
}
" [defConfigureW];

	defBuildW = FullDepEntry "
buildW() {
    if test -n \"\$buildPhase\"; then
        eval \"\$buildPhase\"
        return
    fi

    eval \"\$preBuild\"
    
    echo \"make flags: \$makeFlags \${makeFlagsArray[@]} \$buildFlags \${buildFlagsArray[@]}\"
    make \
        \$makeFlags \"\${makeFlagsArray[@]}\" \
        \$buildFlags \"\${buildFlagsArray[@]}\" || fail

    eval \"\$postBuild\"
}
" [initPath];

	defBuildPhase = FullDepEntry "
buildPhase() {
    if test \"\$dontBuild\" = 1; then
        return
    fi
    header \"building\"
    startLog \"build\"
    buildW
    stopLog
    stopNest
}
" [defBuildW];


	defCheckW = FullDepEntry "
checkW() {
    if test -n \"\$checkPhase\"; then
        eval \"\$checkPhase\"
        return
    fi

    if test -z \"\$checkTarget\"; then
        checkTarget=\"check\"
    fi

    echo \"check flags: \$makeFlags \${makeFlagsArray[@]} \$checkFlags \${checkFlagsArray[@]}\"
    make \
        \$makeFlags \"\${makeFlagsArray[@]}\" \
        \$checkFlags \"\${checkFlagsArray[@]}\" \$checkTarget || fail
}
" [initPath];


	defCheckPhase = FullDepEntry "
checkPhase() {
    if test \"\$doCheck\" != 1; then
        return
    fi
    header \"checking\"
    startLog \"check\"
    checkW
    stopLog
    stopNest
}
" [checkPhase];


	defPatchElf = FullDepEntry "
patchELF() {
    # Patch all ELF executables and shared libraries.
    header \"patching ELF executables and libraries\"
    find \"\$prefix\" \( \
        \( -type f -a -name \"*.so*\" \) -o \
        \( -type f -a -perm +0100 \) \
        \) -print -exec patchelf --shrink-rpath {} \;
    stopNest
}
" [initPath defNest];


	defInstallW = FullDepEntry "
installW() {
    if test -n \"\$installPhase\"; then
        eval \"\$installPhase\"
        return
    fi

    eval \"\$preInstall\"

    ensureDir \"\$prefix\"

    if test -z \"\$installCommand\"; then
        if test -z \"\$installTargets\"; then
            installTargets=install
        fi
        echo \"install flags: \$installTargets \$makeFlags \${makeFlagsArray[@]} \$installFlags \${installFlagsArray[@]}\"
        make \$installTargets \
            \$makeFlags \"\${makeFlagsArray[@]}\" \
            \$installFlags \"\${installFlagsArray[@]}\" || fail
    else
        eval \"\$installCommand\"
    fi

    eval \"\$postInstall\"
}
" [initPath];

	
	defInstallPhase = FullDepEntry "
installPhase() {
    if test \"\$dontInstall\" = 1; then
        return
    fi
    header \"installing\"
    startLog \"install\"
    installW
    stopLog
    stopNest
}
" [defInstallW defNest defStartStopLog];


	defFixupW = FullDepEntry "
# The fixup phase performs generic, package-independent, Nix-related
# stuff, like running patchelf and setting the
# propagated-build-inputs.  It should rarely be overriden.
fixupW() {
    if test -n \"\$fixupPhase\"; then
        eval \"\$fixupPhase\"
        return
    fi

    eval \"\$preFixup\"

 	forceShare=\${forceShare:=man doc info}
 	if test -n \"\$forceShare\"; then
 		for d in \$forceShare; do
 			if test -d \"\$prefix/\$d\"; then
 				if test -d \"\$prefix/share/\$d\"; then
 					echo \"Both \$d/ and share/\$d/ exists, aborting\" 
 				else
 					ensureDir \$prefix/share
					if test -w \$prefix/share; then
	 					mv -v \$prefix/\$d \$prefix/share
 						ln -sv share/\$d \$prefix
					fi
 				fi
 			fi
 		done;
 	fi
 
 
# TODO : strip _only_ ELF executables, and return || fail here...
    if test -z \"\$dontStrip\"; then
		test -d \"\$prefix/lib\" && stripDebug=\"\$prefix/lib\"

		if test -n \"\$stripDebug\"; then
			find \"\$stripDebug\" -type f -print0 |
			xargs -0 strip --strip-debug --verbose || true
		fi

		test -d \"\$prefix/bin\" && stripAll=\"\$prefix/bin\"
		test -d \"\$prefix/sbin\" && stripAll=\"\${stripAll} \$prefix/sbin\"
		if test -n \"\$stripAll\"; then
			find \"\$prefix/bin\" \"\$prefix/sbin\" -type f -print0 |
			xargs -0 strip --strip-all --verbose || true
		fi
    fi

	if test -z \"\$dontFixupShare\"; then
		for dir in doc info man; do
			if test -d \"\$prefix/\$dir\"; then
				if test -d \"\$prefix/share/\$dir\"; then
					echo Both \"\$prefix/\$dir\" and \"\$prefix/share/\$dir\" exists!
				else
					echo Fixing location of \$dir/ subdirectory
					ensureDir \"\$prefix/share\"
					if test -w \$prefix/share; then
						mv -v \"\$prefix/\$dir\" \"\$prefix/share\"
						ln -sv \"share/\$dir\" \"\$prefix\"
					fi
				fi
			fi
		done
	fi

    if test \"\$havePatchELF\" = 1 -a -z \"\$dontPatchELF\"; then
        patchELF \"\$prefix\"
    fi

    if test -n \"\$propagatedBuildInputs\"; then
        ensureDir \"\$out/nix-support\"
        echo \"\$propagatedBuildInputs\" > \"\$out/nix-support/propagated-build-inputs\"
    fi

	if test -n \"\$setupHook\"; then
		ensureDir \"\$out/nix-support\"
		substituteAll \"\$setupHook\" \"\$out/nix-support/setup-hook\"
	fi

    eval \"\$postFixup\"
}
" [defPatchElf initPath];


	defFixupPhase = FullDepEntry "
fixupPhase() {
    if test \"\$dontFixup\" = 1; then
        return
    fi
    header \"post-installation fixup\"
    startLog \"fixup\"
    fixupW
    stopLog
    stopNest
}
" [defFixupW defNest defStartStopLog];


	defDistW = FullDepEntry "
distW() {
    if test -n \"\$distPhase\"; then
        eval \"\$distPhase\"
        return
    fi

    eval \"\$preDist\"
    
    if test -z \"\$distTarget\"; then
        distTarget=\"dist\"
    fi

    echo \"dist flags: \$distFlags \${distFlagsArray[@]}\"
    make \$distFlags \"\${distFlagsArray[@]}\" \$distTarget || fail

    if test \"\$dontCopyDist\" != 1; then
        ensureDir \"\$out/tarballs\"

        if test -z \"\$tarballs\"; then
            tarballs=\"*.tar.gz\"
        fi

        # Note: don't quote \$tarballs, since we explicitly permit
        # wildcards in there.
        cp -pvd \$tarballs \$out/tarballs
    fi

    eval \"\$postDist\"
}
" [initPath ];


	defDistPhase = FullDepEntry "
distPhase() {
    if test \"\$doDist\" != 1; then
        return
    fi
    header \"creating distribution\"
    startLog \"dist\"
    distW
    stopLog
    stopNest
}
" [defDistW defNest defStartStopLog];

	defGenericBuild = FullDepEntry "
genericBuild() {
    header \"building \$out\"

    if test -n \"\$buildCommand\"; then
        eval \"\$buildCommand\"
        return
    fi

    if test -z \"\$phases\"; then
        phases=\"unpackPhase patchPhase configurePhase buildPhase checkPhase \
            installPhase fixupPhase distPhase\";
    fi

    for i in \$phases; do
        dumpVars
        eval \"\$i\"
    done
    
    stopNest
}
" [defUnpackPhase defBuildPhase defInstallPhase];

doDumpVars = FullDepEntry "
dumpVars
" [defDumpVars];
