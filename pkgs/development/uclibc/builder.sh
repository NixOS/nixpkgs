source $stdenv/setup

preBuild=preBuild

preBuild() {
  cp $config .config
}

genericBuild
