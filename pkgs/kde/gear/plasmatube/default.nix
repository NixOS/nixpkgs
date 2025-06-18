{
  lib,
  mkKdeDerivation,
  qtquick3d,
  qtsvg,
  pkg-config,
  mpv-unwrapped,
  yt-dlp,
}:
mkKdeDerivation {
  pname = "plasmatube";

  extraNativeBuildInputs = [ pkg-config ];
  extraBuildInputs = [
    qtquick3d
    qtsvg
    mpv-unwrapped
  ];

  qtWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [ yt-dlp ])
  ];
  meta.mainProgram = "plasmatube";
}
