{
  lib,
  mkKdeDerivation,
  qtquick3d,
  qtsvg,
  purpose,
  qqc2-desktop-style,
  pkg-config,
  mpv-unwrapped,
  yt-dlp,
}:
mkKdeDerivation {
  pname = "plasmatube";

  extraNativeBuildInputs = [pkg-config];
  extraBuildInputs = [qtquick3d qtsvg mpv-unwrapped qqc2-desktop-style];
  extraPropagatedBuildInputs = [purpose];

  qtWrapperArgs = ["--prefix" "PATH" ":" (lib.makeBinPath [ yt-dlp ])];
  meta.mainProgram = "plasmatube";
}
