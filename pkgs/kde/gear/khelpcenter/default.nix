{
  mkKdeDerivation,
  replaceVars,
  qtwebengine,
  xapian,
  man-db,
  python3,
  kio-extras,
}:
mkKdeDerivation {
  pname = "khelpcenter";

  extraBuildInputs = [
    qtwebengine
    xapian
    python3
    kio-extras
  ];
  patches = [
    (replaceVars ./use_nix_paths_for_mansearch_utilities.patch {
      inherit man-db;
    })
  ];
  meta.mainProgram = "khelpcenter";
}
