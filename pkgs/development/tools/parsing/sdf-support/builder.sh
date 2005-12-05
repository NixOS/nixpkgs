source $stdenv/setup
configureFlags="--with-aterm=$aterm --with-toolbuslib=$toolbuslib --with-pt-support=$ptsupport"
genericBuild
