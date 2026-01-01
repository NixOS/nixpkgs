{
  lib,
  stdenv,
  mkDerivation,
  compatIfNeeded,
  libelf,
<<<<<<< HEAD
  elfcopy,
}:
mkDerivation {
  path = "usr.sbin/kldxref";
  extraPaths = [
    "lib/libkldelf"
  ];

  buildInputs = lib.optionals (!stdenv.hostPlatform.isFreeBSD) [ libelf ] ++ compatIfNeeded;

  extraNativeBuildInputs = [
    elfcopy
  ];

  preBuild = ''
    make -C $BSDSRCDIR/lib/libkldelf $makeFlags
  '';

=======
}:
mkDerivation {
  path = "usr.sbin/kldxref";

  buildInputs = lib.optionals (!stdenv.hostPlatform.isFreeBSD) [ libelf ] ++ compatIfNeeded;

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  # We symlink in our modules, make it follow symlinks
  postPatch = ''
    sed -i 's/FTS_PHYSICAL/FTS_LOGICAL/' $BSDSRCDIR/usr.sbin/kldxref/kldxref.c
  '';
}
