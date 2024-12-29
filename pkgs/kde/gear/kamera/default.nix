{
  mkKdeDerivation,
  pkg-config,
  libgphoto2,
}:
mkKdeDerivation {
  pname = "kamera";

  extraNativeBuildInputs = [pkg-config];
  extraBuildInputs = [libgphoto2];
}
