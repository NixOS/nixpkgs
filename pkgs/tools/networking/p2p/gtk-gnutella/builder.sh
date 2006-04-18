source $stdenv/setup

configureScript="./Configure"

dontAddPrefix=1

configureFlags="-d -e -D prefix=$out -D gtkversion=2 -D official=true"

genericBuild