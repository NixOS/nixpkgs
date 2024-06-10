{
  mkKdeDerivation,
  pkg-config,
  libheif,
  libjxl,
  libavif,
  libraw,
  openexr_3,
}:
mkKdeDerivation {
  pname = "kimageformats";

  extraCmakeFlags = ["-DKIMAGEFORMATS_HEIF=1"];
  extraNativeBuildInputs = [pkg-config];
  extraBuildInputs = [libheif libjxl libavif libraw openexr_3];
}
