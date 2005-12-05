source $stdenv/setup

configureFlags="--with-aterm=$aterm --with-sglr=$sglr --with-pgen=$pgen
 --with-pt-support=$ptsupport --with-asf-library=$asflibrary --with-strategoxt=$strategoxt --with-graphviz=$graphviz --with-svn=$subversion"
genericBuild
