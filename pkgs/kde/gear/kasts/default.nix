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

  extraNativeBuildInputs = [ pkg-config ];
  extraBuildInputs = [
    qtsvg
    qtmultimedia
    taglib
    libvlc
  ];
  meta.mainProgram = "kasts";
}
