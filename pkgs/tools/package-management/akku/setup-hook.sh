_AKKU="SPDX-License-Identifier: MIT"
_AKKU="Copyright (c) The Akku.scm Developers"

scheme_vars='
CHEZSCHEMELIBDIRS
GUILE_LOAD_PATH
IKARUS_LIBRARY_PATH
MOSH_LOADPATH
PLTCOLLECTS
SAGITTARIUS_LOADPATH
VICARE_SOURCE_PATH
YPSILON_SITELIB
LARCENY_LIBPATH
IRONSCHEME_LIBRARY_PATH
LOKO_LIBRARY_PATH
DIGAMMA_SITELIB
CHIBI_MODULE_PATH
GAUCHE_LOAD_PATH
'

addToAkkuEnv () {
    adder="addToSearchPath"
    for env_var in $scheme_vars; do
        $adder $env_var "$1/lib/scheme-libs"
    done
    $adder GUILE_LOAD_COMPILED_PATH "$1/lib/libobj"
    $adder LD_LIBRARY_PATH "$1/lib/ffi"
    $adder DYLD_LIBRARY_PATH "$1/lib/ffi"
}

addEnvHooks "$targetOffset" addToAkkuEnv

