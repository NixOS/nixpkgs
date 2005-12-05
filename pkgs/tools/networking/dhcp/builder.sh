source $stdenv/setup

export DESTDIR=$out

configurePhase() {
	./configure
        prefix=$out
}

preBuild() {
	sed -e "s^@nettools\@^$nettools^g" \
	-e "s^@coreutils\@^$coreutils^g" \
	-e "s^@bash\@^$bash^g" \
	-e "s^@iputils\@^$iputils^g" \
	-e "s^@gnused\@^$gnused^g" \
	< client/scripts/linux > client/scripts/linux.tmp
	mv client/scripts/linux.tmp client/scripts/linux
}

preBuild=preBuild

configurePhase=configurePhase

genericBuild
