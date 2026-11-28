{
  mkKdeDerivation,
  fetchpatch,
}:
mkKdeDerivation {
  pname = "union";

  patches = [
    # https://bugs.kde.org/show_bug.cgi?id=528917
    # Drop when 6.8.4 lands
    (fetchpatch {
      url = "https://invent.kde.org/plasma/union/-/commit/192f393d77d183a007521436914b8c189a0c655b.patch";
      hash = "sha256-LSpXkgcDRWjJIGkvwLZ7rlkdRwU9UTJkCG2Fzqt0eVU=";
    })
  ];
}
