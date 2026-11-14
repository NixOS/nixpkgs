{
  mkKdeDerivation,
  pkg-config,
  attr,
  ebook_tools,
  exiv2,
  ffmpeg,
  kconfig,
  kdegraphics-mobipocket,
  libappimage,
  lib,
  stdenv,
}:
mkKdeDerivation {
  pname = "kfilemetadata";

  # Fix installing cmake files into wrong directory
  # FIXME(later): upstream
  patches = [ ./cmake-install-paths.patch ];

  extraNativeBuildInputs = [ pkg-config ];
  extraBuildInputs = [
    ebook_tools
    exiv2
    ffmpeg
    kconfig
    kdegraphics-mobipocket
  ]
  ++ lib.filter (lib.meta.availableOn stdenv.hostPlatform) [
    libappimage
    attr
  ];
}
