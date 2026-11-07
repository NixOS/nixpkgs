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
  version = "0-unstable-2026-11-07";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "utilities";
    repo = "kwi";
    rev = "f226e487f500a955304b8c64e80d663252709b57";
    hash = "sha256-twpBOZLYCMO3D4GGjaxFd+rt4+HXhjacZIBn76j1hAY=";
  };

  __structuredAttrs = true;
  strictDeps = true;

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
