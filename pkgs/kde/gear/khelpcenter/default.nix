{
  mkKdeDerivation,
  qtwebengine,
  xapian,
  man-db,
  python3,
}:
mkKdeDerivation {
  pname = "khelpcenter";

  extraBuildInputs = [
    qtwebengine
    xapian
    man-db
    python3
  ];
  postPatch = ''
    substituteInPlace searchhandlers/khc_mansearch.py \
      --replace-fail "'whatis'" "'${man-db}/bin/whatis'" \
      --replace-fail "'apropos'" "'${man-db}/bin/apropos'"
  '';
  meta.mainProgram = "khelpcenter";
}
