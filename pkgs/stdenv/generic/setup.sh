set -e

test -z $NIX_GCC && NIX_GCC=@gcc@


# Set up the initial path.
PATH=
for i in $NIX_GCC @initialPath@; do
    PATH=$PATH${PATH:+:}$i/bin
done

if test "$NIX_DEBUG" = "1"; then
    echo "Initial path: $PATH"
fi


# Execute the pre-hook.
param1=@param1@
param2=@param2@
param3=@param3@
param4=@param4@
param5=@param5@
if test -n "@preHook@"; then
    . @preHook@
fi


# Check that the pre-hook initialised SHELL.
if test -z "$SHELL"; then echo "SHELL not set"; exit 1; fi


# Hack: run gcc's setup hook.
envHooks=()
if test -f $NIX_GCC/nix-support/setup-hook; then
    . $NIX_GCC/nix-support/setup-hook
fi

    
# Recursively find all build inputs.
findInputs()
{
    local pkg=$1

    case $pkgs in
        *\ $pkg\ *)
            return 0
            ;;
    esac
    
    pkgs="$pkgs $pkg "

    if test -f $pkg/nix-support/setup-hook; then
        . $pkg/nix-support/setup-hook
    fi
    
    if test -f $pkg/nix-support/propagated-build-inputs; then
        for i in $(cat $pkg/nix-support/propagated-build-inputs); do
            findInputs $i
        done
    fi
}

pkgs=""
if test -n "$buildinputs"; then
    buildInputs="$buildinputs" # compatibility
fi
for i in $buildInputs $propagatedBuildInputs; do
    findInputs $i
done


# Set the relevant environment variables to point to the build inputs
# found above.
addToEnv()
{
    local pkg=$1

    if test -d $1/bin; then
        export _PATH=$_PATH${_PATH:+:}$1/bin
    fi

    for i in "${envHooks[@]}"; do
        $i $pkg
    done
}

for i in $pkgs; do
    addToEnv $i
done


# Add the output as an rpath.
if test "$NIX_NO_SELF_RPATH" != "1"; then
    export NIX_LDFLAGS="-rpath $out/lib $NIX_LDFLAGS"
fi


# Strip debug information by default.
export NIX_STRIP_DEBUG=1
export NIX_CFLAGS_STRIP="-g0 -Wl,-s"


# Do we know where the store is?  This is required for purity checking.
if test -z "$NIX_STORE"; then
    echo "Error: you have an old version of Nix that does not set the" \
        "NIX_STORE variable.  Please upgrade." >&2
    exit 1
fi


# We also need to know the root of the build directory for purity checking.
if test -z "$NIX_BUILD_TOP"; then
    echo "Error: you have an old version of Nix that does not set the" \
        "NIX_BUILD_TOP variable.  Please upgrade." >&2
    exit 1
fi


# Set the TZ (timezone) environment variable, otherwise commands like
# `date' will complain (e.g., `Tue Mar 9 10:01:47 Local time zone must
# be set--see zic manual page 2004').
export TZ=UTC


# Execute the post-hook.
if test -n "@postHook@"; then
    . @postHook@
fi

PATH=$_PATH${_PATH:+:}$PATH
if test "$NIX_DEBUG" = "1"; then
    echo "Final path: $PATH"
fi


######################################################################
# What follows is the generic builder.


nestingLevel=0

startNest() {
    nestingLevel=$(($nestingLevel + 1))
    echo -en "\e[$1p"
}

stopNest() {
    nestingLevel=$(($nestingLevel - 1))
    echo -en "\e[q"
}

header() {
    startNest "$2"
    echo "$1"
}

# Make sure that even when we exit abnormally, the original nesting
# level is properly restored.
closeNest() {
    while test $nestingLevel -gt 0; do
        stopNest
    done
}

trap "closeNest" EXIT


# Utility function: return the base name of the given path, with the
# prefix `HASH-' removed, if present.
stripHash() {
    strippedName=$(basename $1);
    if echo "$strippedName" | grep -q '^[a-f0-9]\{32\}-'; then
        strippedName=$(echo "$strippedName" | cut -c34-)
    fi
}


unpackFile() {
    local file=$1
    local cmd

    case $file in
        *.tar) cmd="tar xvf $file";;
        *.tar.gz | *.tgz | *.tar.Z) cmd="tar xvfz $file";;
        *.tar.bz2 | *.tbz2) cmd="tar xvfj $file";;
        *.zip) cmd="unzip $file";;
        *)
            if test -d "$file"; then
                stripHash $file
                cmd="cp -prvd $file $strippedName"
            else
                if test -n "$findUnpacker"; then
                    $findUnpacker $1;
                fi
                if test -z "$unpackCmd"; then
                    echo "source archive $file has unknown type"
                    exit 1
                fi
                cmd=$unpackCmd
            fi
            ;;
    esac

    header "unpacking source archive $file (using $cmd)" 3
    $cmd
    stopNest
}


unpackW() {
    if test -n "$unpackPhase"; then
        $unpackPhase
        return
    fi

    if test -z "$srcs"; then
        if test -z "$src"; then
            echo 'variable $src or $srcs should point to the source'
            exit 1
        fi
        srcs="$src"
    fi

    # To determine the source directory created by unpacking the
    # source archives, we record the contents of the current
    # directory, then look below which directory got added.  Yeah,
    # it's rather hacky.
    local dirsBefore=""
    for i in *; do
        if test -d "$i"; then
            dirsBefore="$dirsBefore $i "
        fi
    done

    # Unpack all source archives.
    for i in $srcs; do
        unpackFile $i
    done

    # Find the source directory.
    if test -n "$setSourceRoot"; then
        $setSourceRoot
    else
        sourceRoot=
        for i in *; do
            if test -d "$i"; then
                case $dirsBefore in
                    *\ $i\ *)
                        ;;
                    *)
                        if test -n "$sourceRoot"; then
                            echo "unpacker produced multiple directories"
                            exit 1
                        fi
                        sourceRoot=$i
                        ;;
                esac
            fi
        done
    fi

    if test -z "$sourceRoot"; then
        echo "unpacker appears to have produced no directories"
        exit 1
    fi

    echo "source root is $sourceRoot"

    if test -n "$postUnpack"; then
        $postUnpack
    fi
}


unpackPhase() {
    header "unpacking sources"
    unpackW
    stopNest
}


patchW() {
    if test -n "$patchPhase"; then
        $patchPhase
        return
    fi

    for i in $patches; do
        header "applying patch $i" 3
        patch -p1 < $i
        stopNest
    done
}


patchPhase() {
    if test -z "$patchPhase" -a -z "$patches"; then return; fi
    header "patching sources"
    patchW
    stopNest
}


fixLibtool() {
    sed 's^eval sys_lib_.*search_path=.*^^' < $1 > $1.tmp
    mv $1.tmp $1
}


configureW() {
    if test -n "$configurePhase"; then
        $configurePhase
        stopNest
        return
    fi

    if test -n "$preConfigure"; then
        $preConfigure
    fi

    if test -z "$configureScript"; then
        configureScript=./configure
    fi
    
    if ! test -x $configureScript; then
        echo "no configure script, doing nothing"
        return
    fi

    if test -z "$dontFixLibtool" -a -f ./ltmain.sh; then
        for i in $(find . -name "ltmain.sh"); do
            echo "fixing libtool script $i"
            fixLibtool $i
        done
    fi

    if test -z "$dontAddPrefix"; then
        configureFlags="--prefix=$out $configureFlags"
    fi

    echo "configure flags: $configureFlags"
    $configureScript $configureFlags

    if test -n "$postConfigure"; then
        $postConfigure
    fi
}


configurePhase() {
    header "configuring"
    configureW
    stopNest
}


buildW() {
    if test -n "$buildPhase"; then
        $buildPhase
        return
    fi

    if test -z "$dontMake"; then
        echo "make flags: $makeFlags"
        make $makeFlags
    fi
}


buildPhase() {
    header "building"
    buildW
    stopNest
}


installW() {
    if test -n "$installPhase"; then
        $installPhase
        return
    fi
    
    if test -n "$preInstall"; then
        $preInstall
    fi

    if ! test -x "$out"; then mkdir "$out"; fi
    
    if test -z "$dontMakeInstall"; then
        echo "install flags: $installFlags"
        make install $installFlags
    fi

    if test -z "$dontStrip" -a "$NIX_STRIP_DEBUG" = 1; then
        find "$out" -name "*.a" -exec echo stripping {} \; -exec strip -S {} \;
    fi

    if test -n "$propagatedBuildInputs"; then
        if ! test -x "$out/nix-support"; then mkdir "$out/nix-support"; fi
        echo "$propagatedBuildInputs" > "$out/nix-support/propagated-build-inputs"
    fi

    if test -n "$postInstall"; then
        $postInstall
    fi
}


installPhase() {
    header "installing"
    installW
    stopNest
}


genericBuild() {
    header "building $out"
    unpackPhase
    cd $sourceRoot
    patchPhase
    configurePhase
    buildPhase
    installPhase
    stopNest
}
