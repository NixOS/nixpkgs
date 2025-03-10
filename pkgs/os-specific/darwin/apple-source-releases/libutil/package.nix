{
  apple-sdk_14,
  copyfile,
  mkAppleDerivation,
}:

mkAppleDerivation {
  releaseName = "libutil";

  outputs = [
    "out"
    "dev"
    "man"
  ];

  xcodeHash = "sha256-LwR9fmvcdJ/QYlOx+7ffhV4mKvjkwN3rX3+yHSCovKQ=";

  patches = [
    # The only change from macOS 13 to 14 was setting this flag. Check at runtime and only set if supported.
    ./patches/0001-Conditionally-pre-condition.patch
  ];

  buildInputs = [
    (apple-sdk_14.override { enableBootstrap = true; })
    copyfile
  ];

  meta.description = "System utilities library";
}
