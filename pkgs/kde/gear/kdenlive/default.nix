{
  mkKdeDerivation,
  substituteAll,
  qtsvg,
  qtmultimedia,
  qtnetworkauth,
  qqc2-desktop-style,
  ffmpeg-full,
  mediainfo,
  mlt,
  shared-mime-info,
  libv4l,
  frei0r,
}:
mkKdeDerivation {
  pname = "kdenlive";

  patches = [
    (substituteAll {
      src = ./dependency-paths.patch;
      inherit mediainfo mlt;
      ffmpeg = ffmpeg-full;
    })
  ];

  extraBuildInputs = [
    qtsvg
    qtmultimedia
    qtnetworkauth

    qqc2-desktop-style

    mlt
    shared-mime-info
    libv4l
  ];

  qtWrapperArgs = [
    "--set FREI0R_PATH ${frei0r}/lib/frei0r-1"
  ];
}
