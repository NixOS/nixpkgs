{
  mkKdeDerivation,
  replaceVars,
  mlt,
  frei0r,
  opencv4,
  glaxnimate,
  ffmpeg-full,
  ffmpegthumbs,
  pkg-config,
  shared-mime-info,
  qtsvg,
  qtmultimedia,
  qtnetworkauth,
  kddockwidgets,
  qqc2-desktop-style,
  libv4l,
  kio-extras,
  opentimelineio,
  qtimageformats,
  lib,
  stdenv,
}:
let
  # Make sure only a single copy of opencv gets into the closure
  # With multiple the application will crash
  # Same issue as shotcut had
  frei0r' = frei0r.override {
    opencv = opencv4.override { ffmpeg-headless = mlt.ffmpeg; };
  };
in
mkKdeDerivation {
  pname = "kdenlive";

  patches = [
    (replaceVars ./dependency-paths.patch {
      inherit mlt glaxnimate;
      ffmpeg = ffmpeg-full;
    })
  ];

  extraCmakeFlags = [
    "-DFETCH_OTIO=0"
  ];

  extraNativeBuildInputs = [
    pkg-config
    shared-mime-info
  ];

  extraBuildInputs = [
    qtsvg
    qtmultimedia
    qtnetworkauth
    qtimageformats # UI uses webp images

    kddockwidgets
    qqc2-desktop-style
    kio-extras

    ffmpeg-full
    ffmpegthumbs
    mlt
    opentimelineio
  ]
  ++ lib.filter (lib.meta.availableOn stdenv.hostPlatform) [
    libv4l
  ];

  qtWrapperArgs = [
    "--set FREI0R_PATH ${frei0r'}/lib/frei0r-1"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "--set MLT_PREFIX ${mlt}"
  ];

  meta.mainProgram = "kdenlive";
  meta.platforms = lib.platforms.unix;
}
