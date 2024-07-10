{
  mkKdeDerivation,
  qtdeclarative,
  qtsvg,
  fetchpatch,
}:
mkKdeDerivation {
  pname = "ksvg";

  patches = [
    # Backport patch for SVG rendering glitches with fractional scale
    # FIXME: remove in 6.4
    (fetchpatch {
      url = "https://invent.kde.org/frameworks/ksvg/-/commit/74f9f9cbd226407f8cde08c5cd5a711444e2775d.patch";
      hash = "sha256-i4Wcvo0CkpN2qdlTesnzUyd0mzG1VKbycP5Pd1rHPVg=";
    })
  ];

  extraBuildInputs = [qtdeclarative qtsvg];
}
