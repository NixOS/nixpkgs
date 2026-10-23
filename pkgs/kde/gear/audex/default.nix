{
  mkKdeDerivation,
  libcdio,
  libcdio-paranoia,
}:
mkKdeDerivation {
  pname = "audex";

  extraBuildInputs = [
    libcdio
    libcdio-paranoia
  ];
}
