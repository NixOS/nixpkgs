{
  mkKdeDerivation,
  qtsvg,
  qtmultimedia,
  pkg-config,
  taglib_1,
  libvlc,
}:
mkKdeDerivation {
  pname = "kasts";

  extraNativeBuildInputs = [ pkg-config ];
  extraBuildInputs = [
    qtsvg
    qtmultimedia
    taglib_1
    libvlc
  ];
  meta.mainProgram = "kasts";
}
