######################################################################
# check and installCheck phases
# Note: check is done between build and installation;
#   installCheck is run *after* installation and fixup.

checkPhase() {
    runHook preCheck

    echo "check flags: $makeFlags ${makeFlagsArray[@]} $checkFlags ${checkFlagsArray[@]}"
    make ${makefile:+-f $makefile} \
        ${enableParallelBuilding:+-j${NIX_BUILD_CORES} -l${NIX_BUILD_CORES}} \
        $makeFlags "${makeFlagsArray[@]}" \
        ${checkFlags:-VERBOSE=y} "${checkFlagsArray[@]}" ${checkTarget:-check}

    runHook postCheck
}

installCheckPhase() {
    runHook preInstallCheck

    echo "installcheck flags: $makeFlags ${makeFlagsArray[@]} $installCheckFlags ${installCheckFlagsArray[@]}"
    make ${makefile:+-f $makefile} \
        ${enableParallelBuilding:+-j${NIX_BUILD_CORES} -l${NIX_BUILD_CORES}} \
        $makeFlags "${makeFlagsArray[@]}" \
        $installCheckFlags "${installCheckFlagsArray[@]}" ${installCheckTarget:-installcheck}

    runHook postInstallCheck
}

