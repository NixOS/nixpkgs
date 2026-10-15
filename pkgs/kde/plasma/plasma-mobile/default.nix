{
  mkKdeDerivation,
  pkg-config,
  qtsensors,
  qtwayland,
  plasma-workspace,
}:
mkKdeDerivation {
  pname = "plasma-mobile";

  extraNativeBuildInputs = [ pkg-config ];
  extraBuildInputs = [
    qtsensors
    qtwayland
  ];

  # FIXME: work around Qt 6.10 cmake API changes
  cmakeFlags = [ "-DQT_FIND_PRIVATE_MODULES=1" ];

  postFixup = ''
    substituteInPlace "$out/share/wayland-sessions/plasma-mobile.desktop" \
      --replace-fail \
        "$out/libexec/plasma-dbus-run-session-if-needed" \
        "${plasma-workspace}/libexec/plasma-dbus-run-session-if-needed"
  '';
  passthru.providedSessions = [ "plasma-mobile" ];
}
