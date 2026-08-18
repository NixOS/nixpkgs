{
  lib,
  stdenv,
  mkDerivation,
  compatIfNeeded,
  libelf,
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

  # We symlink in our modules, make it follow symlinks
  postPatch = ''
    sed -i 's/FTS_PHYSICAL/FTS_LOGICAL/' $BSDSRCDIR/usr.sbin/kldxref/kldxref.c
  '';
}
