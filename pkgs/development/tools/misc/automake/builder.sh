. $stdenv/setup


postInstall() {

    # Create a wrapper around `aclocal' that converts every element in
    # `ACLOCAL_PATH' into a `-I dir' option.  This way `aclocal'
    # becomes modular; M4 macros do not need to be stored in a single
    # global directory, while callers of `aclocal' do not need to pass
    # `-I' options explicitly.

    mv $out/bin/aclocal $out/bin/_tmp

    for i in $out/bin/aclocal*; do
        rm $i
        ln -s aclocal $i
    done

    cat > $out/bin/aclocal <<EOF
#! $SHELL -e

oldIFS=\$IFS
IFS=:
extra=
for i in \$ACLOCAL_PATH; do
    if test -n "\$i"; then
        extra="\$extra -I \$i"
    fi
done
IFS=\$oldIFS

exec $out/bin/aclocal-orig \${extra[@]} "\$@"
EOF
    chmod +x $out/bin/aclocal
    mv $out/bin/_tmp $out/bin/aclocal-orig


    # Automatically let `ACLOCAL_PATH' include all build inputs that
    # have a `.../share/aclocal' directory.
    test -x $out/nix-support || mkdir $out/nix-support
    cp -p $setupHook $out/nix-support/setup-hook

}
postInstall=postInstall


genericBuild
