source $stdenv/setup

preBuild() {
  cd src
}

preBuild=preBuild

preInstall() {
  ensureDir $out/bin
}

preInstall=preInstall

genericBuild
