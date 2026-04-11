{
  mkKdeDerivation,
  pkg-config,
  libwacom,
  xf86-input-wacom,
}:
mkKdeDerivation {
  pname = "wacomtablet";

  extraNativeBuildInputs = [ pkg-config ];
  extraBuildInputs = [
    libwacom
    xf86-input-wacom
  ];
  meta.mainProgram = "kde_wacom_tabletfinder";
}
