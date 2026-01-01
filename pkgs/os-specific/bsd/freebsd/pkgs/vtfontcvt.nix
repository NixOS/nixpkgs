{ mkDerivation }:
mkDerivation {
  path = "usr.bin/vtfontcvt";
  extraPaths = [ "sys/cddl/contrib/opensolaris/common/lz4" ];
<<<<<<< HEAD

  NIX_CFLAGS_COMPILE = [
    "-Wno-unterminated-string-initialization"
  ];
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}
