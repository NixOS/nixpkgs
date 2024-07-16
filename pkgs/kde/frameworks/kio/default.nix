{
  mkKdeDerivation,
  fetchpatch,
  qt5compat,
  qttools,
  acl,
  attr,
}:
mkKdeDerivation {
  pname = "kio";

  patches = [
    # Remove hardcoded smbd search path
    ./0001-Remove-impure-smbd-search-path.patch

    # Backport fix for drag and drop
    # FIXME: remove in next update
    (fetchpatch {
      url = "https://invent.kde.org/frameworks/kio/-/commit/e0ea91afdf0dccef7e3afbf23a159bf5a8d6b249.patch";
      hash = "sha256-YtklZr4DwV8wNABIAUm969w90hi4iEk5aW7a3n6yQeM=";
    })
  ];

  extraBuildInputs = [qt5compat qttools acl attr];
}
