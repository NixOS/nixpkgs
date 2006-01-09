# This is the builder for all X11R7 components.
source $stdenv/setup


# After installation, automatically add all "Requires" fields in the
# pkgconfig files (*.pc) to the propagated build inputs.
postInstall=postInstall
postInstall() {
    local r p requires
    requires=$(grep "Requires:" $out/lib/pkgconfig/*.pc | \
        sed "s/Requires://" | sed "s/,/ /g")

    echo "propagating requisites $requires"

    for r in $requires; do
        for p in $pkgs; do
#            echo $r $p
            if test -e $p/lib/pkgconfig/$r.pc; then
                echo "  found requisite $r in $p"
                propagatedBuildInputs="$propagatedBuildInputs $p"
            fi
        done
    done

    ensureDir "$out/nix-support"
    echo "$propagatedBuildInputs" > "$out/nix-support/propagated-build-inputs"
}


installFlags="appdefaultdir=$out/share/X11/app-defaults"


if test -n "$x11BuildHook"; then
    source $x11BuildHook
fi   


genericBuild
