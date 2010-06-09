source $stdenv/setup

makeFlagsArray=(LCRYPT=-lcrypt BIN_OWNER=$(id -u) BIN_GROUP=$(id -g) ROOT=$out)

preBuild="cd src"

preInstall() {
    substituteInPlace Makefile --replace /usr /
    mkdir $out
    mkdir $out/bin
    mkdir $out/sbin
    mkdir $out/include
    mkdir $out/share
    mkdir $out/share/man
    mkdir $out/share/man/man1
    mkdir $out/share/man/man5
    mkdir $out/share/man/man8
}

postInstall() {
    if test -n "$withoutInitTools"; then
	mv $out/sbin/killall5 $out/bin
	ln -sf killall5 $out/bin/pidof
	rm -rf $out/sbin
	rm -rf $out/include
	rm -rf $out/share/man/man5
	rm $(for i in $out/share/man/man8/*; do echo $i; done | grep -v 'pidof\|killall5')
    fi
}

genericBuild
