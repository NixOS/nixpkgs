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
    taglib
    libvlc
  ];
  meta.mainProgram = "kasts";
}
