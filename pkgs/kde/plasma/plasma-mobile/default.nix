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

  # Upstream hardcodes an FHS path in envmanager/config.h for the default
  # kwinrc InputMethod. plasma-mobile-envmanager writes this to
  # ~/.config/plasma-mobile/kwinrc as an immutable ([$i]) entry, so it cannot
  # be overridden by /etc/xdg. Rewrite the prefix to the NixOS system path so
  # the on-screen keyboard loads on first boot.
  postPatch = ''
    substituteInPlace envmanager/config.h \
      --replace-fail "/usr/share/applications/org.kde.plasma.keyboard.desktop" \
      "/run/current-system/sw/share/applications/org.kde.plasma.keyboard.desktop"
  '';

  postFixup = ''
    substituteInPlace "$out/share/wayland-sessions/plasma-mobile.desktop" \
      --replace-fail \
        "$out/libexec/plasma-dbus-run-session-if-needed" \
        "${plasma-workspace}/libexec/plasma-dbus-run-session-if-needed"
  '';
  passthru.providedSessions = [ "plasma-mobile" ];
}
