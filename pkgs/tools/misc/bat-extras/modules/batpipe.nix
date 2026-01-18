{
  lib,
  stdenv,
  buildBatExtrasPkg,
  less,
  procps,
}:
buildBatExtrasPkg {
  name = "batpipe";
  dependencies = [
    less
    procps
  ];

  patches = [
    ../patches/batpipe-skip-outdated-test.patch
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    ../patches/batpipe-skip-detection-tests.patch
  ];

  meta.description = "Less (and soon bat) preprocessor for viewing more types of files in the terminal";
}
