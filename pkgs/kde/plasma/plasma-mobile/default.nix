{
  mkKdeDerivation,
  pkg-config,
  qtsensors,
  plasma-workspace,
}:
mkKdeDerivation {
  pname = "plasma-mobile";

  extraNativeBuildInputs = [pkg-config];
  extraBuildInputs = [qtsensors];
  postFixup = ''
    substituteInPlace "$out/share/wayland-sessions/plasma-mobile.desktop" \
      --replace-fail \
        "$out/libexec/plasma-dbus-run-session-if-needed" \
        "${plasma-workspace}/libexec/plasma-dbus-run-session-if-needed"
  '';
  passthru.providedSessions = [ "plasma-mobile" ];
}
