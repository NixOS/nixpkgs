source $stdenv/setup

preBuild=preBuild

preBuild() {
  cp $config .config
  makeFlags="CROSS=$cross-";
}

genericBuild
