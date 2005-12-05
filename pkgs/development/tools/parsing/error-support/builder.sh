source $stdenv/setup
configureFlags="--with-aterm=$aterm --with-toolbuslib=$toolbuslib"
genericBuild
