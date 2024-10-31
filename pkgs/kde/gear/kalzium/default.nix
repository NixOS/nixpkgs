{
  mkKdeDerivation,
  fetchpatch,
  pkg-config,
  ocaml,
  eigen,
  openbabel,
  qtsvg,
  qtscxml,
}:
mkKdeDerivation {
  pname = "kalzium";

  patches = [
    # Fix build with Qt 6.8
    # FIXME: remove in next major update
    (fetchpatch {
      url = "https://invent.kde.org/education/kalzium/-/commit/557d9bc96636f413430d0789cbf775915fc0dc45.patch";
      hash = "sha256-KDCT/COqk7OTuF8pN7qrRrIPRU4PSGm+efpCDGbtZwA=";
    })
  ];

  # FIXME: look into how to make it find libfacile
  extraNativeBuildInputs = [
    pkg-config
    ocaml
  ];
  extraBuildInputs = [
    eigen
    openbabel
    qtsvg
    qtscxml
  ];
  meta.mainProgram = "kalzium";
}
