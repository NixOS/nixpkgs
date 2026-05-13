{
  mkKdeDerivation,
  pkg-config,
  plymouth,
}:
mkKdeDerivation {
  pname = "plymouth-kcm";

  extraNativeBuildInputs = [ pkg-config ];
  extraBuildInputs = [ plymouth ];
  meta.mainProgram = "kplymouththemeinstaller";
}
