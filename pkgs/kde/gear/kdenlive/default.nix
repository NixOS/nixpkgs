{
  mkKdeDerivation,
  replaceVars,
  mlt,
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
  frei0r,
  shaderc,
}:
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

  # Workaround until https://github.com/NixOS/nixpkgs/pull/480475 hits master
  NIX_LDFLAGS = [ "-L${shaderc.lib}/lib -lshaderc_shared" ];

  extraNativeBuildInputs = [
    pkg-config
    shared-mime-info
  ];

  extraBuildInputs = [
    qtsvg
    qtmultimedia
    qtnetworkauth

    kddockwidgets
    qqc2-desktop-style
    kio-extras

    ffmpeg-full
    ffmpegthumbs
    libv4l
    mlt
    opentimelineio
  ];

  qtWrapperArgs = [
    "--set FREI0R_PATH ${frei0r}/lib/frei0r-1"
  ];

  meta.mainProgram = "kdenlive";
}
