. $stdenv/setup

export DESTDIR=$out

configurePhase() {
	./configure
        prefix=$out
}

configurePhase=configurePhase

genericBuild
