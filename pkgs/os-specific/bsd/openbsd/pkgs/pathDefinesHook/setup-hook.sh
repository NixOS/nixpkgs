# include this hook to override the filepath #defines in <paths.h>
# adding `PATH_DEFINE__PATH_BSHELL = runtimeShell` to your derivation will add
# `#define _PATH_BSHELL ${runtimeShell}` to your include/paths.h

pathDefinesIncludeFile="$TMP/pathDefinesInclude/paths.h"
setupPathDefinesHeader() {
    mkdir -p "$(dirname "$pathDefinesIncludeFile")"
    (
        echo "#ifndef _PATH_DEFINES_NIXPKGS_H"
        echo "#define _PATH_DEFINES_NIXPKGS_H"
        echo "#include_next <paths.h>"
        echo
        # enumerate environment searching for PATH_DEFINE_*
        # https://stackoverflow.com/questions/39529648/how-to-iterate-through-all-the-env-variables-printing-key-and-value
        while IFS='=' read -r -d '' envName envValue; do
            if [[ "$envName" == PATH_DEFINE_* ]]; then
                defineName="${envName#PATH_DEFINE_}"
                echo "#ifdef ${defineName}"
                echo "#undef ${defineName}"
                echo "#endif"
                echo "#define ${defineName} \"${envValue}\""
                echo
            fi
        done < <(env -0)
        echo "#endif"
    ) >"$pathDefinesIncludeFile"
    export NIX_CFLAGS_COMPILE_BEFORE="$NIX_CFLAGS_COMPILE_BEFORE -I$(dirname "$pathDefinesIncludeFile")"
}

preConfigureHooks+=(setupPathDefinesHeader)
