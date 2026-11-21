{
  lib,
  mkKdeDerivation,
  fetchFromGitLab,

  pkg-config,
  libghostty-vt,

  extra-cmake-modules,
  kdbusaddons,
  kio,
  kirigami,
  kirigami-addons,
  kirigami-app-components,
  knotifications,
  kparts,
  kpty,
  kwindowsystem,
  kxmlgui,
  qtquick3d,

  nix-update-script,
}:

mkKdeDerivation {
  pname = "kwi";
  version = "0.1.0-unstable-2026-11-14";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "utilities";
    repo = "kwi";
    rev = "cac652b1f40fa8fcb92f988ad455413a31ef51a1";
    hash = "sha256-yHU/ehXIM7lNdgmUC8ASIG0Y753K9O4TOX0AHuqnBT4=";
  };

  __structuredAttrs = true;
  strictDeps = true;
  doCheck = false; # Requires dbus with a config, fontconfig, etc

  extraNativeBuildInputs = [
    pkg-config
  ];

  extraBuildInputs = [
    libghostty-vt

    extra-cmake-modules
    kdbusaddons
    kio
    kirigami
    kirigami-addons
    kirigami-app-components
    knotifications
    kparts
    kpty
    kwindowsystem
    kxmlgui
    qtquick3d
  ];

  passthru = {
    updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };
  };

  meta = {
    description = "Modern and fast terminal for KDE Plasma and other desktops";
    homepage = "https://invent.kde.org/utilities/kwi";
    license =
      with lib.licenses;
      (AND [
        # libs
        (OR [
          lgpl21Only
          lgpl3Only
          lgpl3Plus # KDE-Accepted-LGPL
        ])
        # app
        (OR [
          gpl2Only
          gpl3Only
          gpl3Plus # KDE-Accepted-GPL
        ])
      ]);
    maintainers = with lib.maintainers; [ sandarukasa ];
    mainProgram = "kwi";
  };
}
