# This is the builder for all X.org components.
source $stdenv/setup


# After installation, automatically add all "Requires" fields in the
# pkgconfig files (*.pc) to the propagated build inputs.
origPostInstall=$postInstall
postInstall() {
    if test -n "$origPostInstall"; then eval "$origPostInstall"; fi

    local r p requires
    requires=$(grep "Requires:" $out/lib/pkgconfig/*.pc | \
        sed "s/Requires://" | sed "s/,/ /g")

    echo "propagating requisites $requires"

    for r in $requires; do
        if test -n "$crossConfig"; then
            for p in $crossPkgs; do
                if test -e $p/lib/pkgconfig/$r.pc; then
                    echo "  found requisite $r in $p"
                    propagatedBuildInputs="$propagatedBuildInputs $p"
                fi
            done
        else
            for p in $nativePkgs; do
                if test -e $p/lib/pkgconfig/$r.pc; then
                    echo "  found requisite $r in $p"
                    propagatedBuildNativeInputs="$propagatedBuildNativeInputs $p"
                fi
            done
        fi
    done

    ensureDir "$out/nix-support"
    echo "$propagatedBuildInputs" > "$out/nix-support/propagated-build-inputs"
    echo "$propagatedBuildNativeInputs" > "$out/nix-support/propagated-build-native-inputs"
}


installFlags="appdefaultdir=$out/share/X11/app-defaults"


if test -n "$x11BuildHook"; then
    source $x11BuildHook
fi   


genericBuild
