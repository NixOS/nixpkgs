poetry2nix-fixup-hook() {

    # Including tests in the output is a common mistake
    if [ -z "${dontFixupTests-}" ]; then
        rm -rf $out/@pythonSitePackages@/tests
    fi

    # Including files in site-packages is a common packaging mistake
    #
    # While we cannot remove all normal files dumped in site-packages
    # we can clean up some common mistakes
    if [ -z "${dontFixupSitePackages-}" ]; then
        for f in @filenames@; do
            rm -f $out/@pythonSitePackages@/$f
        done
    fi

}

postFixupHooks+=(poetry2nix-fixup-hook)
