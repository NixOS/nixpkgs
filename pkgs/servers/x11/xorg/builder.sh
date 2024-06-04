if [ -e "$NIX_ATTRS_SH_FILE" ]; then . "$NIX_ATTRS_SH_FILE"; elif [ -f .attrs.sh ]; then . .attrs.sh; fi
# This is the builder for all X.org components.
source $stdenv/setup


# After installation, automatically add all "Requires" fields in the
# pkgconfig files (*.pc) to the propagated build inputs.
origPostInstall=$postInstall
postInstall() {
    if test -n "$origPostInstall"; then eval "$origPostInstall"; fi

    local r p requires
    set +o pipefail
    requires=$(grep "Requires:" ${!outputDev}/lib/pkgconfig/*.pc | \
        sed "s/Requires://" | sed "s/,/ /g")
    set -o pipefail

    echo "propagating requisites $requires"

    for r in $requires; do
        for p in "${pkgsHostHost[@]}" "${pkgsHostTarget[@]}"; do
            if test -e $p/lib/pkgconfig/$r.pc; then
                echo "  found requisite $r in $p"
                propagatedBuildInputs+=" $p"
            fi
        done
    done
}


installFlags="appdefaultdir=$out/share/X11/app-defaults $installFlags"


if test -n "$x11BuildHook"; then
    source $x11BuildHook
fi


enableParallelBuilding=1
enableParallelInstalling=1

genericBuild
