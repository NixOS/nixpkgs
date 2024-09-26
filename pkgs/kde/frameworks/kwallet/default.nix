{
  mkKdeDerivation,
  libgcrypt,
  kcrash,
  kdoctools,
}:
mkKdeDerivation {
  pname = "kwallet";

  extraBuildInputs = [
    libgcrypt
    kcrash
    kdoctools
  ];
}
