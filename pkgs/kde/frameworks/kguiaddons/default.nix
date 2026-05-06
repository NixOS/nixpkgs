{
  mkKdeDerivation,
  qtwayland,
  pkg-config,
}:
mkKdeDerivation {
  pname = "kguiaddons";

  hasPythonBindings = true;

  extraNativeBuildInputs = [ pkg-config ];
  extraBuildInputs = [ qtwayland ];
  meta.mainProgram = "kde-geo-uri-handler";
}
