{
  mkKdeDerivation,
  qtsensors,
  dbus,
}:
mkKdeDerivation {
  pname = "kscreen";

  extraBuildInputs = [ qtsensors ];

  postFixup = ''
    substituteInPlace $out/share/kglobalaccel/org.kde.kscreen.desktop \
      --replace-fail dbus-send ${dbus}/bin/dbus-send
  '';
  meta.mainProgram = "kscreen-console";
}
