{
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

  buildInputs = [
    copyfile
  ];

  meta.description = "System utilities library";
}
