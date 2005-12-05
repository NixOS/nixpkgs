source $stdenv/setup
configureFlags="--with-aterm=$aterm \
                --with-toolbuslib=$toolbuslib \
                --with-pt-support=$ptsupport \
                --with-sdf-support=$sdfsupport \
                --with-asf-support=$asfsupport \
                --with-asc-support=$asfsupport \
                --with-sglr=$sglr"
genericBuild
