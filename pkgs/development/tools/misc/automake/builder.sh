if [ -e .attrs.sh ]; then source .attrs.sh; fi
source $stdenv/setup

# Wrap the given `aclocal' program, appending extra `-I' flags
# corresponding to the directories listed in $ACLOCAL_PATH.  (Note
# that `wrapProgram' can't be used for that purpose since it can only
# prepend flags, not append them.)
wrapAclocal() {
    local program="$1"
    local wrapped="$(dirname $program)/.$(basename $program)-wrapped"

    mv "$program" "$wrapped"
    cat > "$program"<<EOF
#! $SHELL -e

unset extraFlagsArray
declare -a extraFlagsArray

oldIFS=\$IFS
IFS=:
for dir in \$ACLOCAL_PATH; do
    if test -n "\$dir" -a -d "\$dir"; then
        extraFlagsArray=("\${extraFlagsArray[@]}" "-I" "\$dir")
    fi
done
IFS=\$oldIFS

exec "$wrapped" "\$@" "\${extraFlagsArray[@]}"
EOF
    chmod +x "$program"
}

postInstall() {
    # Create a wrapper around `aclocal' that converts every element in
    # `ACLOCAL_PATH' into a `-I dir' option.  This way `aclocal'
    # becomes modular; M4 macros do not need to be stored in a single
    # global directory, while callers of `aclocal' do not need to pass
    # `-I' options explicitly.

    for prog in $out/bin/aclocal*; do
        wrapAclocal "$prog"
    done

    ln -s aclocal-1.11 $out/share/aclocal
    ln -s automake-1.11 $out/share/automake
}

genericBuild
