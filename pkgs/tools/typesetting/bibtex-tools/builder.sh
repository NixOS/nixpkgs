source $stdenv/setup

configureFlags="--with-aterm=$aterm --with-sdf=$sdf --with-strategoxt=$strategoxt --with-hevea=$hevea --with-latex=$tetex"
genericBuild
