{
  mkKdeDerivation,
  qtwayland,
  pkg-config,
}:
mkKdeDerivation {
  pname = "kguiaddons";

  extraNativeBuildInputs = [ pkg-config ];
  extraBuildInputs = [ qtwayland ];
  meta.mainProgram = "kde-geo-uri-handler";
}
