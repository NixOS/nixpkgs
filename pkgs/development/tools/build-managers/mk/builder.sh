source $stdenv/setup
installFlags="PREFIX=$out"
preInstall="mkdir -p $out/man/man1 $out/bin"
genericBuild
