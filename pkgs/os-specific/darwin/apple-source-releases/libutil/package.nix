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

  xcodeHash = "sha256-7t2yz022PUuVwMQP7NBB3I9neuhxJin5W2C+Y5IQYAA=";

  buildInputs = [
    copyfile
  ];

  meta.description = "System utilities library";
}
