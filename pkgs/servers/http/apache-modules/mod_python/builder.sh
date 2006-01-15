source $stdenv/setup

installFlags="LIBEXECDIR=$out/modules $installFlags"

ensureDir $out/modules

genericBuild
