{
  mkKdeDerivation,
  libarchive,
  libzip,
}:
mkKdeDerivation {
  pname = "ark";

  extraBuildInputs = [
    libarchive
    (libzip.override { withOpenssl = true; })
  ];
  meta.mainProgram = "ark";
}
