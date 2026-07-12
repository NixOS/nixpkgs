{ mkKdeDerivation }:
mkKdeDerivation {
  pname = "kate";

  outputs = [
    "out"
    "kwrite"
    "dev"
    "devtools"
  ];

  postInstall = ''
    moveToOutput bin/kwrite "$kwrite"
    moveToOutput share/applications/org.kde.kwrite.desktop "$kwrite"
    moveToOutput share/metainfo/org.kde.kwrite.appdata.xml "$kwrite"
    moveToOutput "share/icons/hicolor/*/apps/kwrite.*" "$kwrite"
  '';

  # Keep KWrite documentation out of the Kate output
  postFixup = ''
    moveToOutput "share/doc/HTML/*/kwrite" "$kwrite"
  '';

  meta.mainProgram = "kate";
}
