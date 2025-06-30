{
  mkKdeDerivation,
  replaceVars,
  lib,
  mediainfo,
  mlt,
  glaxnimate,
  ffmpeg-full,
  pkg-config,
  shared-mime-info,
  qtsvg,
  qtmultimedia,
  qtnetworkauth,
  qqc2-desktop-style,
  libv4l,
  open-timeline-io,
  frei0r,
  rnnoise-plugin,
  enablePlugins ? true,
}:
mkKdeDerivation {
  pname = "kdenlive";

  patches = [
    (replaceVars ./dependency-paths.patch {
      inherit mediainfo mlt glaxnimate;
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

    qqc2-desktop-style

    ffmpeg-full
    libv4l
    mlt
    open-timeline-io
  ];

  qtWrapperArgs = lib.optionals enablePlugins [
    "--set FREI0R_PATH ${frei0r}/lib/frei0r-1"
    "--prefix LADSPA_PATH : ${rnnoise-plugin}/lib/ladspa"
  ];

  meta.mainProgram = "kdenlive";
}
