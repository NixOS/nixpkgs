#! @shell@ -e

params="$@"

if test -n "$NIX_GCC_WRAPPER_START_HOOK"; then
    source "$NIX_GCC_WRAPPER_START_HOOK"
fi

export NIX_CFLAGS_COMPILE="@cflagsCompile@ $NIX_CFLAGS_COMPILE"
export NIX_CFLAGS_LINK="@cflagsLink@ $NIX_CFLAGS_LINK"
export NIX_LDFLAGS="@ldflags@ $NIX_LDFLAGS"
export NIX_LDFLAGS_BEFORE="@ldflagsBefore@ $NIX_LDFLAGS_BEFORE"
export NIX_GLIBC_FLAGS_SET=1

source @out@/nix-support/utils

# Figure out if linker flags should be passed.  GCC prints annoying
# warnings when they are not needed.
dontLink=0
if test "$*" = "-v" -o -z "$*"; then
    dontLink=1
else
    for i in "$@"; do
        if test "$i" = "-c"; then
            dontLink=1
        elif test "$i" = "-S"; then
            dontLink=1
        elif test "$i" = "-E"; then
            dontLink=1
        elif test "$i" = "-E"; then
            dontLink=1
        elif test "$i" = "-M"; then
            dontLink=1
        elif test "$i" = "-MM"; then
            dontLink=1
        fi
    done
fi

# Add the flags for the C compiler proper.
extraAfter="$NIX_CFLAGS_COMPILE"
extraBefore=""

if test "$dontLink" != "1"; then
    # Add the flags that should only be passed to the compiler when
    # linking.
    extraAfter="$extraAfter $NIX_CFLAGS_LINK"

    # Add the flags that should be passed to the linker (and prevent
    # `ld-wrapper' from adding NIX_LDFLAGS again).
    for i in $NIX_LDFLAGS_BEFORE; do
        extraBefore="$extraBefore -Wl,$i"
    done
    for i in $NIX_LDFLAGS; do
	if test "${i:0:3}" = "-L"; then
	    extraAfter="$extraAfter $i"
	else
	    extraAfter="$extraAfter -Wl,$i"
	fi
    done
    export NIX_LDFLAGS_SET=1

    if test "$NIX_STRIP_DEBUG" = "1"; then
        # Add executable-stripping flags.
        extraAfter="$extraAfter $NIX_CFLAGS_STRIP"
    fi
fi

# As a very special hack, if the arguments are just `-v', then don't
# add anything.  This is to prevent `gcc -v' (which normally prints
# out the version number and returns exit code 0) from printing out
# `No input files specified' and returning exit code 1.
if test "$*" = "-v"; then
    extraAfter=""
    extraBefore=""
fi    

if test -n "$NIX_GCC_WRAPPER_EXEC_HOOK"; then
    source "$NIX_GCC_WRAPPER_EXEC_HOOK"
fi

# Call the real `gcc'.  Filter out warnings from stderr about unused
# `-B' flags, since they confuse some programs.  Deep bash magic to
# apply grep to stderr (by swapping stdin/stderr twice).
if test -z "$NIX_GCC_NEEDS_GREP"; then
    @gccProg@ $extraBefore $params $extraAfter
else
    (@gccProg@ $extraBefore $params $extraAfter 3>&2 2>&1 1>&3- \
        | (grep -v 'file path prefix' || true); exit ${PIPESTATUS[0]}) 3>&2 2>&1 1>&3-
    exit $?
fi    
