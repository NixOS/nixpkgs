source $stdenv/setup

export installFlags="PREFIX=$out"

preBuild() {
	cp $config .config
}

preBuild=preBuild

genericBuild
