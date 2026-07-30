{
  mkKdeDerivation,
  pkg-config,
  libcanberra,
  pulseaudio,
}:
mkKdeDerivation {
  pname = "plasma-pa";

  extraNativeBuildInputs = [ pkg-config ];
  extraBuildInputs = [
    libcanberra
    pulseaudio
  ];
}
