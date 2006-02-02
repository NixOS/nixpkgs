source $stdenv/setup
export BIN=$out/bin
export LIB=$out/lib
export MAN=$out/man
# What location for texinputs (tex macro's used by noweb)?
export TEXINPUTS=$out/share/texmf/tex/latex
export SHELL
makeFlags="-e"
installFlags="-e"
preInstall="mkdir -p $TEXINPUTS"
genericBuild
