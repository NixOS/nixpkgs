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

  patches = [
    (replaceVars ./use_nix_paths_for_mansearch_utilities.patch {
      inherit man-db;
    })
  ];

  extraNativeBuildInputs = [
    qtwebengine
  ];

  extraBuildInputs = [
    qtwebengine
    xapian
    python3
    kio-extras
  ];

  meta.mainProgram = "khelpcenter";
}
