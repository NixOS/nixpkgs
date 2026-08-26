{
  mkKdeDerivation,
  pkg-config,
  ffmpeg,
}:
mkKdeDerivation {
  pname = "ffmpegthumbs";

  extraNativeBuildInputs = [ pkg-config ];
  extraBuildInputs = [ ffmpeg ];
}
