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
}:
mkKdeDerivation {
  pname = "kfilemetadata";

  # Fix installing cmake files into wrong directory
  # FIXME(later): upstream
  patches = [./cmake-install-paths.patch];

  extraNativeBuildInputs = [pkg-config];
  extraBuildInputs = [attr ebook_tools exiv2 ffmpeg kconfig kdegraphics-mobipocket libappimage];
}
