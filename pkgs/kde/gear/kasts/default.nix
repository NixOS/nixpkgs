{
  mkKdeDerivation,
  qtsvg,
  qtmultimedia,
  pkg-config,
  taglib,
  libvlc,
}:
mkKdeDerivation {
  pname = "kasts";

  extraNativeBuildInputs = [
    pkg-config
    qtmultimedia
  ];

  extraBuildInputs = [
    qtsvg
    qtmultimedia
    taglib
    libvlc
  ];
  meta.mainProgram = "kasts";
}
