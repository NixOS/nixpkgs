{
  mkKdeDerivation,
  pkg-config,
  libcanberra,
  pulseaudio,
}:
mkKdeDerivation {
  pname = "plasma-pa";

  outputs = [
    "out"
    "doc"
  ];

  extraNativeBuildInputs = [ pkg-config ];
  extraBuildInputs = [
    libcanberra
    pulseaudio
  ];
}
