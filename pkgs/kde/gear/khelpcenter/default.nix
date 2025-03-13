{
  mkKdeDerivation,
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
    man-db
    python3
    kio-extras
  ];
  postPatch = ''
    substituteInPlace searchhandlers/khc_mansearch.py \
      --replace-fail "'whatis'" "'${man-db}/bin/whatis'" \
      --replace-fail "'apropos'" "'${man-db}/bin/apropos'"
  '';
  meta.mainProgram = "khelpcenter";
}
