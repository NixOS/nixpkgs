addLinuxMakeFlags() {
    prependToVar makeFlags @commonMakeFlags@
}

preConfigureHooks+=(addLinuxMakeFlags)
