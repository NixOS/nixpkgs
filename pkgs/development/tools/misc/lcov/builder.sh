source $stdenv/setup

installFlags="PREFIX=$out"

preInstall=preInstall
preInstall() {
    substituteInPlace bin/install.sh --replace /bin/bash $shell

    for i in bin/*; do
        echo "fixing $i..."
        sed -e "s^@PREFIX@^$out^" \
            -e "s^@PERL@^$perl/bin/perl^" \
            < $i > $i.tmp
        mv $i.tmp $i
        chmod +x $i
    done
}

genericBuild
