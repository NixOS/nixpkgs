{
  mkKdeDerivation,
  qtquick3d,
  pkg-config,
  pipewire,
  ffmpeg,
  libgbm,
  libva,
}:
mkKdeDerivation {
  pname = "kpipewire";

  extraNativeBuildInputs = [ pkg-config ];
  extraBuildInputs = [
    qtquick3d
    pipewire
    ffmpeg
    libgbm
    libva
  ];
}
