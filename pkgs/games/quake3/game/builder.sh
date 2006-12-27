source $stdenv/setup

ensureDir $out/baseq3
installTargets=copyfiles
installFlags="COPYDIR=$out"

genericBuild
