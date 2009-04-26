source $stdenv/setup


postInstall() {
    # Create a wrapper around `aclocal' that converts every element in
    # `ACLOCAL_PATH' into a `-I dir' option.  This way `aclocal'
    # becomes modular; M4 macros do not need to be stored in a single
    # global directory, while callers of `aclocal' do not need to pass
    # `-I' options explicitly.

    for prog in $out/bin/aclocal*; do 
        wrapProgram $prog --run \
            '
oldIFS=$IFS
IFS=:
for dir in $ACLOCAL_PATH; do
    if test -n "$dir" -a -d "$dir"; then
        extraFlagsArray=("${extraFlagsArray[@]}" "-I" "$dir")
    fi
done
IFS=$oldIFS'
    done
}


genericBuild
