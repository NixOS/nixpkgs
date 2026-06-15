{
  mkKdeDerivation,
  libarchive,
  libzip,
}:
mkKdeDerivation {
  pname = "ark";

  outputs = [
    "out"
    "man"
    "doc"
  ];

  extraBuildInputs = [
    libarchive
    (libzip.override { withOpenssl = true; })
  ];
  meta.mainProgram = "ark";
}
