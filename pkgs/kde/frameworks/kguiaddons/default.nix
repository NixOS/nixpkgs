{
  mkKdeDerivation,
  qtwayland,
  pkg-config,
  wayland-protocols,
}:
mkKdeDerivation {
  pname = "kguiaddons";

  hasPythonBindings = true;

  extraNativeBuildInputs = [ pkg-config ];
  extraBuildInputs = [
    qtwayland
    wayland-protocols
  ];
  meta.mainProgram = "kde-geo-uri-handler";
}
