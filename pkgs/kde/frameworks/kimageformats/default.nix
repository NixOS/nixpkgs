{
  mkKdeDerivation,
  pkg-config,
  libheif,
  libjxl,
  libavif,
  libraw,
  openexr,
}:
mkKdeDerivation {
  pname = "kimageformats";

  extraCmakeFlags = [ "-DKIMAGEFORMATS_HEIF=1" ];
  extraNativeBuildInputs = [ pkg-config ];
  extraBuildInputs = [
    libheif
    libjxl
    # FIXME: cmake files are broken, disabled for now
    # libavif
    libraw
    openexr
  ];
}
