{
  mkKdeDerivation,
  fetchpatch,
  libarchive,
  libzip,
}:
mkKdeDerivation {
  pname = "ark";

  # Backport fix to clean up temporary folders with Qt 6.7
  # FIXME: remove in next update
  patches = [
    (fetchpatch {
      url = "https://invent.kde.org/utilities/ark/-/commit/85c5e26f581cf011638a53e62b92e1da8fd55fcd.patch";
      hash = "sha256-ZjVdKgFoGE0Jme8JhGVn7+PODJqdwHQhglrHzsxePf8=";
    })
  ];

  extraBuildInputs = [libarchive libzip];
  meta.mainProgram = "ark";
}
