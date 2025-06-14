{
  mkKdeDerivation,
  pkg-config,
  xz,
}:
mkKdeDerivation {
  pname = "karchive";

  extraNativeBuildInputs = [ pkg-config ];
  extraBuildInputs = [ xz ];
}
