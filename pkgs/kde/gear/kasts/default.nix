{
  mkKdeDerivation,
  qtsvg,
  qtmultimedia,
  pkg-config,
  qqc2-desktop-style,
  taglib,
  libvlc,
}:
mkKdeDerivation {
  pname = "kasts";

  extraNativeBuildInputs = [pkg-config];
  extraBuildInputs = [
    qtsvg
    qtmultimedia
    qqc2-desktop-style
    taglib
    libvlc
  ];
  meta.mainProgram = "kasts";
}
