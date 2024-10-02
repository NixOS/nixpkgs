{
  mkKdeDerivation,
  libcanberra,
  libvlc,
}:
mkKdeDerivation {
  pname = "kalarm";

  extraBuildInputs = [
    libcanberra
    libvlc
  ];
}
