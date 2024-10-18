{
  mkKdeDerivation,
  shared-mime-info,
}:
mkKdeDerivation {
  pname = "cantor";

  extraNativeBuildInputs = [ shared-mime-info ];
  # FIXME(qt5)
  meta.broken = true;
}
