. $stdenv/setup

buildPhase() {
	cp $config .config
	make
}

buildPhase=buildPhase

genericBuild
