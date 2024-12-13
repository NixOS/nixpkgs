{
  mkKdeDerivation,
  ffmpeg,
}:
mkKdeDerivation {
  pname = "ffmpegthumbs";

  extraBuildInputs = [ ffmpeg ];
}
