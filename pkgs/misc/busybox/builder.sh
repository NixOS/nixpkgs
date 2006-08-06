source $stdenv/setup

export installFlags="PREFIX=$out"

preBuild() {
	cp $config .config
	make include/bb_config.h
}

preBuild=preBuild

genericBuild
