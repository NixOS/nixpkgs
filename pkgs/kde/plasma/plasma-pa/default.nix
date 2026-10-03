{
  mkKdeDerivation,
  pkg-config,
  libcanberra,
  pulseaudio,
}:
mkKdeDerivation {
  pname = "plasma-pa";

  patches = [
    # https://invent.kde.org/plasma/plasma-pa/-/merge_requests/431
    ./reproducible-build.patch
  ];

  extraNativeBuildInputs = [ pkg-config ];
  extraBuildInputs = [
    libcanberra
    pulseaudio
  ];
}
