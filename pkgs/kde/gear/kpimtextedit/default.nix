{
  mkKdeDerivation,
  qt5compat,
  fetchpatch,
}:
mkKdeDerivation {
  pname = "kpimtextedit";

  # Fix build with Qt 6.9
  # FIXME: remove in 25.04
  patches = [
    (fetchpatch {
      url = "https://invent.kde.org/pim/kpimtextedit/-/commit/2c36ea1bdd1dcb60cd042a10668d64447484615d.patch";
      hash = "sha256-Uo8yl5v9tpjXRF1AtlCGnFhprOEug9WCdmfyb+DHSUQ=";
    })
  ];

  extraBuildInputs = [ qt5compat ];
}
