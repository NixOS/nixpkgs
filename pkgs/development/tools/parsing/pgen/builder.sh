. $stdenv/setup
configureFlags="--with-aterm=$aterm \
                --with-toolbuslib=$toolbuslib \
                --with-pt-support=$ptsupport \
                --with-sdf-support=$sdfsupport \
                --with-asf-support=$asfsupport \
                --with-asc-support=$asfsupport \
                --with-sglr=$sglr"
genericBuild

mkdir $out/nix-support
echo "$getopt" > $out/nix-support/propagated-build-inputs
