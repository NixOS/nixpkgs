{
  mkKdeDerivation,
  pkg-config,
  ffmpeg,
  lib,
}:
mkKdeDerivation {
  pname = "ffmpegthumbs";

  extraNativeBuildInputs = [ pkg-config ];
  extraBuildInputs = [ ffmpeg ];

  meta.platforms = lib.platforms.unix;
}
