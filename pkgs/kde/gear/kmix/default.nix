{
  mkKdeDerivation,

  alsa-lib,
  libcanberra,
  libpulseaudio,
}:
mkKdeDerivation {
  pname = "kmix";

  extraBuildInputs = [
    alsa-lib
    libcanberra
    libpulseaudio
  ];
}
