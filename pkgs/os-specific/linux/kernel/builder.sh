. $stdenv/setup

buildPhase() {
	cp $config .config
	echo "export INSTALL_PATH=$out" >> Makefile
	export INSTALL_MOD_PATH=$out
	make
	make modules_install
}

buildPhase=buildPhase

genericBuild
